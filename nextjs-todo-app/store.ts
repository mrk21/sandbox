import {
  createStore as reduxCreateStore,
  combineReducers,
  applyMiddleware,
  Store,
} from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import countReducer, { CountState, initialCountState } from './reducers/countReducer';
import todoReducer, { TodoState, initialTodoState } from './reducers/todoReducer';

export type RootState = {
  count: CountState,
  todo: TodoState,
};

export type AppStore = Store<RootState>;

const reducers = combineReducers({
  count: countReducer,
  todo: todoReducer,
});

export const initialRootState: RootState = {
  count: initialCountState,
  todo: initialTodoState,
};

export function createStore(initialState: RootState = initialRootState): AppStore {
  return reduxCreateStore(
    reducers,
    initialState,
    composeWithDevTools(applyMiddleware()),
  );
}
