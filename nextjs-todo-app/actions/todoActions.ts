import InvalidValueError from '~/lib/InvalidValueError';
import { Action, Dispatch } from 'redux';
import { Todo, makeEntity } from '~/entity/Todo';
import { APIError } from '~/entity/APIError';
import * as todoAPI from '~/api/todo';
import { getUser, UserActions } from '~/actions/userActions';
import { compact, uniq } from 'lodash';
import { throttle } from 'lodash';

export enum TodoActionTypes {
  GET_LIST = 'Todo/GET_LIST',
  SET_LIST = 'Todo/SET_LIST',
  GET = 'Todo/GET',
  APPEND = 'Todo/APPEND',
  ERROR = 'Todo/ERROR',
};

export type TodoAction = {
  GetList: Action<TodoActionTypes.GET_LIST>;
  SetList: Action<TodoActionTypes.SET_LIST> & {
    payload: Todo[];
  }
  Get: Action<TodoActionTypes.GET> & {
    payload: {
      id: string;
    };
  };
  Append: Action<TodoActionTypes.APPEND> & {
    payload: Todo;
  };
  Error: Action<TodoActionTypes.ERROR> & {
    payload: {
      id: string;
      error: APIError;
    };
  };
}
export type TodoActions = TodoAction[keyof TodoAction];

type IncludeOptions = {
  includes: {
    assigner?: boolean;
  };
};
const defaultIncludes: IncludeOptions = {
  includes: {
    assigner: false
  }
};

/**
 * get list
 */
async function _getTodoList(dispatch: Dispatch<TodoActions | UserActions>, { includes } = defaultIncludes) {
  dispatch({
    type: TodoActionTypes.GET_LIST,
  });

  const { data, error } = await todoAPI.getList();

  if (data) {
    dispatch({
      type: TodoActionTypes.SET_LIST,
      payload: data,
    });

    if (includes.assigner) {
      await Promise.all(
        uniq(compact(data.map(todo => todo.assignerId)))
          .map(id => getUser(dispatch, { id }))
      );
    }
  }
  else {
    throw new InvalidValueError('get todo list response', { data, error });
  }
  return 'hoge!!!';
}
const _getTodoListThrottled = throttle(_getTodoList, 1000, { trailing: false });
export async function getTodoList(dispatch: Dispatch<TodoActions | UserActions>, { includes } = defaultIncludes) {
  console.log(`@@@ call: getTodoList`);
  return _getTodoListThrottled(dispatch, { includes });
}

/**
 * get
 */
type GetTodoInput = {
  id: string;
};
export async function getTodo(dispatch: Dispatch<TodoActions | UserActions>, { id }: GetTodoInput, { includes } = defaultIncludes) {
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

    if (includes.assigner && data.assignerId) {
      await getUser(dispatch, { id: data.assignerId });
    }
  }
  else if (error) {
    dispatch({
      type: TodoActionTypes.ERROR,
      payload: { id, error }
    });
  }
  else {
    throw new InvalidValueError('get todo response', { data, error });
  }
}

/**
 * create
 */
export async function createTodo(dispatch: Dispatch<TodoActions>, input: Todo) {
  const { data, error } = await todoAPI.create(input);

  if (data) {
    dispatch({
      type: TodoActionTypes.APPEND,
      payload: data,
    });
  }
  else {
    throw new InvalidValueError('get todo response', { data, error });
  }
}

/**
 * make
 */
export async function makeTodo(dispatch: Dispatch<TodoActions>, input: Partial<Todo>) {
  const newRecord = makeEntity(input);
  dispatch({
    type: TodoActionTypes.APPEND,
    payload: newRecord,
  });
  return newRecord.id;
}
