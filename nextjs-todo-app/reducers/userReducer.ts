import { Reducer } from 'redux';
import { User } from '~/entity/User';
import { APIError } from '~/entity/APIError';
import { UserActionTypes, UserActions } from '../actions/userActions';
import { cloneDeep } from 'lodash';
import { RootState } from '~/store';

export type UserState = {
  records: User[];
  recordIndex: { [key: string]: User | undefined };
  errors: { [key: string]: APIError | undefined };
  loadings: { [key: string]: boolean | undefined };
  loadingAll: boolean;
};

export type UserReducer = Reducer<UserState, UserActions>;

export const initialUserState: UserState = {
  records: [],
  recordIndex: {},
  errors: {},
  loadings: {},
  loadingAll: false,
};

export const userReducer: UserReducer = (state = initialUserState, action) => {
  switch (action.type) {
    case UserActionTypes.GET_LIST: {
      const newState = cloneDeep(state);
      newState.loadingAll = true;
      return newState;
    }
    case UserActionTypes.SET_LIST: {
      const newState = cloneDeep(initialUserState);
      newState.records = action.payload;
      return newState;
    }
    case UserActionTypes.GET: {
      const newState = cloneDeep(state);
      newState.loadings[action.payload.id] = true;
      return newState;
    }
    case UserActionTypes.APPEND: {
      const newState = cloneDeep(state);
      const record = cloneDeep(action.payload);
      const isExisted = record.id in newState.recordIndex;

      newState.recordIndex[record.id] = record;
      if (!isExisted) newState.records.push(record);
      newState.loadings[record.id] = false;
      delete newState.errors[record.id];
      return newState;
    }
    case UserActionTypes.ERROR: {
      const newState = cloneDeep(state);
      const error = cloneDeep(action.payload.error);

      newState.errors[action.payload.id] = error;
      delete newState.loadings[action.payload.id];
      return newState;
    }
    default: {
      return state;
    }
  }
}

export const records = (state: RootState) => cloneDeep(state.user.records);
export const record = (state: RootState, id: string) => cloneDeep(state.user.recordIndex[id]);
export const error = (state: RootState, id: string) => cloneDeep(state.user.errors[id]);
export const isLoading = (state: RootState, id: string) => !!state.user.loadings[id];
export const isLoadingAll = (state: RootState) => state.user.loadingAll;

export default userReducer;
