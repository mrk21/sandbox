import {
  createStore as reduxCreateStore,
  combineReducers,
  applyMiddleware,
  Store,
} from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import todoReducer, { TodoState, initialTodoState } from './reducers/todoReducer';

export type RootState = {
  todo: TodoState,
};

export type AppStore = Store<RootState>;

const reducers = combineReducers({
  todo: todoReducer,
});

export const initialRootState: RootState = {
  todo: initialTodoState,
};

export function createStore(initialState: RootState = initialRootState): AppStore {
  return reduxCreateStore(
    reducers,
    initialState,
    composeWithDevTools(applyMiddleware()),
  );
}
