import { combineReducers } from 'redux';
import { HYDRATE } from "next-redux-wrapper";
import { counterReducer } from '@/modules/counter';

export type RootState = ReturnType<typeof combinedReducer>;

const combinedReducer = combineReducers({
  counter: counterReducer
});

export const rootReducer: typeof combinedReducer = (state, action) => {
  switch (action.type) {
  case HYDRATE:
    return { ...state, ...action.payload };
  default:
    return combinedReducer(state, action);
  }
};
