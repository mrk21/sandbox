import InvalidValueError from '~/lib/InvalidValueError';
import { Action, Dispatch } from 'redux';
import { User, makeEntity } from '~/entity/User';
import { APIError } from '~/entity/APIError';
import * as userAPI from '~/api/user';

export enum UserActionTypes {
  GET_LIST = 'User/GET_LIST',
  SET_LIST = 'User/SET_LIST',
  GET = 'User/GET',
  APPEND = 'User/APPEND',
  ERROR = 'User/ERROR',
};

export type GetUserListAction = Action<UserActionTypes.GET_LIST>;
export type SetUserAction = Action<UserActionTypes.SET_LIST> & {
  payload: User[];
}
export type GetUserAction = Action<UserActionTypes.GET> & {
  payload: {
    id: string;
  };
};
export type AppendUserAction = Action<UserActionTypes.APPEND> & {
  payload: User;
};
export type ErrorUserAction = Action<UserActionTypes.ERROR> & {
  payload: {
    id: string;
    error: APIError;
  };
};
export type UserAction = GetUserListAction | SetUserAction | GetUserAction | AppendUserAction | ErrorUserAction;


/**
 * get list
 */
export async function getUserList(dispatch: Dispatch<UserAction>) {
  dispatch({
    type: UserActionTypes.GET_LIST,
  });

  const { data, error } = await userAPI.getList();

  if (data) {
    dispatch({
      type: UserActionTypes.SET_LIST,
      payload: data,
    });
  }
  else {
    throw new InvalidValueError('get user list response', { data, error });
  }
}

/**
 * get
 */
type GetUserInput = {
  id: string;
};
export async function getUser(dispatch: Dispatch<UserAction>, { id }: GetUserInput) {
  dispatch({
    type: UserActionTypes.GET,
    payload: { id },
  });

  const { data, error } = await userAPI.get({ id });

  if (data) {
    dispatch({
      type: UserActionTypes.APPEND,
      payload: data,
    });
  }
  else if (error) {
    dispatch({
      type: UserActionTypes.ERROR,
      payload: { id, error },
    });
  }
  else {
    throw new InvalidValueError('get user response', { data, error });
  }
}

/**
 * make
 */
export async function makeUser(dispatch: Dispatch<UserAction>, input: Partial<User>) {
  const newRecord = makeEntity(input);
  dispatch({
    type: UserActionTypes.APPEND,
    payload: newRecord,
  });
  return newRecord.id;
}
