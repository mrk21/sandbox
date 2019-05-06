import InvalidValueError from '~/lib/InvalidValueError';
import { Action, Dispatch } from 'redux';
import { Todo } from '~/entity/Todo';
import { APIError } from '~/entity/APIError';
import todoAPI from '~/api/todo';

export enum TodoActionTypes {
  GET = 'Todo/GET',
  APPEND = 'Todo/APPEND',
  ERROR = 'Todo/ERROR',
};

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

export type TodoAction = GetTodoAction | AppendTodoAction | ErrorTodoAction;

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
