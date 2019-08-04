import InvalidValueError from '~/lib/InvalidValueError';
import { User, makeEntity } from '~/entity/User';
import { APIError } from '~/entity/APIError';
import * as userAPI from '~/api/user';
import batchRequest from '~/lib/async/BatchRequest';
import { AppDispatch } from '~/store';

export enum UserActionTypes {
  GET_LIST = 'User/GET_LIST',
  SET_LIST = 'User/SET_LIST',
  GET = 'User/GET',
  APPEND = 'User/APPEND',
  ERROR = 'User/ERROR',
};

export type UserActionTree = {
  GetList: {
    type: UserActionTypes.GET_LIST;
  };
  SetList: {
    type: UserActionTypes.SET_LIST;
    payload: User[];
  };
  Get: {
    type: UserActionTypes.GET;
    payload: {
      id: string;
    };
  };
  Append: {
    type: UserActionTypes.APPEND;
    payload: User;
  };
  Error: {
    type: UserActionTypes.ERROR;
    payload: {
      id: string;
      error: APIError;
    };
  };
};

/**
 * get list
 */
export async function getUserList(dispatch: AppDispatch) {
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
const getUserBatched = batchRequest({
  batchInterval: 50,
  batchMax: 3,
  batchAPI: userAPI.batchGet,
  paramsToId: ({ id }) => id,
});
export async function getUser(dispatch: AppDispatch, { id }: GetUserInput) {
  dispatch({
    type: UserActionTypes.GET,
    payload: { id },
  });

  //const { data, error } = await userAPI.get({ id });
  const { data, error } = await getUserBatched({ id });

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
export async function makeUser(dispatch: AppDispatch, input: Partial<User>) {
  const newRecord = makeEntity(input);
  dispatch({
    type: UserActionTypes.APPEND,
    payload: newRecord,
  });
  return newRecord.id;
}
