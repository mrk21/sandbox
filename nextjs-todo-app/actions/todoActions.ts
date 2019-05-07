import InvalidValueError from '~/lib/InvalidValueError';
import { Action, Dispatch } from 'redux';
import { Todo, makeEntity } from '~/entity/Todo';
import { APIError } from '~/entity/APIError';
import * as todoAPI from '~/api/todo';
import { getUser, UserAction } from '~/actions/userActions';
import { compact, uniq } from 'lodash';

export enum TodoActionTypes {
  GET_LIST = 'Todo/GET_LIST',
  SET_LIST = 'Todo/SET_LIST',
  GET = 'Todo/GET',
  APPEND = 'Todo/APPEND',
  ERROR = 'Todo/ERROR',
};

export type GetTodoListAction = Action<TodoActionTypes.GET_LIST>;
export type SetTodoAction = Action<TodoActionTypes.SET_LIST> & {
  payload: Todo[];
}
export type GetTodoAction = Action<TodoActionTypes.GET> & {
  payload: {
    id: string;
  };
};
export type AppendTodoAction = Action<TodoActionTypes.APPEND> & {
  payload: Todo;
};
export type ErrorTodoAction = Action<TodoActionTypes.ERROR> & {
  payload: {
    id: string;
    error: APIError;
  };
};
export type TodoAction = GetTodoListAction | SetTodoAction | GetTodoAction | AppendTodoAction | ErrorTodoAction;


/**
 * get list
 */
export async function getTodoList(dispatch: Dispatch<TodoAction | UserAction>) {
  dispatch({
    type: TodoActionTypes.GET_LIST,
  });

  const { data, error } = await todoAPI.getList();

  if (data) {
    dispatch({
      type: TodoActionTypes.SET_LIST,
      payload: data,
    });

    await Promise.all(
      uniq(compact(data.map(todo => todo.assignerId)))
        .map(id => getUser(dispatch, { id }))
    );
  }
  else {
    throw new InvalidValueError('get todo list response', { data, error });
  }
}

/**
 * get
 */
type GetTodoInput = {
  id: string;
};
export async function getTodo(dispatch: Dispatch<TodoAction>, { id }: GetTodoInput) {
  dispatch({
    type: TodoActionTypes.GET,
    payload: { id },
  });

  const { data, error } = await todoAPI.get({ id });

  if (data) {
    dispatch({
      type: TodoActionTypes.APPEND,
      payload: data,
    });
  }
  else if (error) {
    dispatch({
      type: TodoActionTypes.ERROR,
      payload: { id, error },
    });
  }
  else {
    throw new InvalidValueError('get todo response', { data, error });
  }
}

/**
 * make
 */
export async function makeTodo(dispatch: Dispatch<TodoAction>, input: Partial<Todo>) {
  const newRecord = makeEntity(input);
  dispatch({
    type: TodoActionTypes.APPEND,
    payload: newRecord,
  });
  return newRecord.id;
}
