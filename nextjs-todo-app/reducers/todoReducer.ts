import { Reducer } from 'redux';
import { Todo } from '~/entity/Todo';
import { APIError } from '~/entity/APIError';
import { TodoActionTypes } from '../actions/todoActions';
import { cloneDeep } from 'lodash';
import { RootState, AppActions } from '~/store';

export type TodoState = {
  records: Todo[];
  recordIndex: { [key: string]: Todo | undefined };
  errors: { [key: string]: APIError | undefined };
  loadings: { [key: string]: boolean | undefined };
  loadingAll: boolean;
};

export type TodoReducer = Reducer<TodoState, AppActions>;

export const initialTodoState: TodoState = {
  records: [],
  recordIndex: {},
  errors: {},
  loadings: {},
  loadingAll: false,
};

export const todoReducer: TodoReducer = (state = initialTodoState, action) => {
  switch (action.type) {
    case TodoActionTypes.GET_LIST: {
      const newState = cloneDeep(state);
      newState.loadingAll = true;
      return newState;
    }
    case TodoActionTypes.SET_LIST: {
      const newState = cloneDeep(initialTodoState);
      newState.records = action.payload;
      return newState;
    }
    case TodoActionTypes.GET: {
      const newState = cloneDeep(state);
      newState.loadings[action.payload.id] = true;
      return newState;
    }
    case TodoActionTypes.APPEND: {
      const newState = cloneDeep(state);
      const record = cloneDeep(action.payload);
      const isExisted = record.id in newState.recordIndex;

      newState.recordIndex[record.id] = record;
      if (!isExisted) newState.records.push(record);
      newState.loadings[record.id] = false;
      delete newState.errors[record.id];
      return newState;
    }
    case TodoActionTypes.ERROR: {
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

export const records = (state: RootState) => cloneDeep(state.todo.records);
export const record = (state: RootState, id: string) => cloneDeep(state.todo.recordIndex[id]);
export const error = (state: RootState, id: string) => cloneDeep(state.todo.errors[id]);
export const isLoading = (state: RootState, id: string) => !!state.todo.loadings[id];
export const isLoadingAll = (state: RootState) => state.todo.loadingAll;

export default todoReducer;
