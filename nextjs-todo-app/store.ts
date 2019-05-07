import {
  createStore as reduxCreateStore,
  combineReducers,
  applyMiddleware,
  Store,
} from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import todoReducer, { TodoState, initialTodoState } from './reducers/todoReducer';
import userReducer, { UserState, initialUserState } from './reducers/userReducer';
import { TodoAction } from './actions/todoActions';
import { UserAction } from './actions/userActions';

export type RootState = {
  todo: TodoState,
  user: UserState,
};

export type RootAction = TodoAction | UserAction;

export type AppStore = Store<RootState, RootAction>;

const reducers = combineReducers({
  todo: todoReducer,
  user: userReducer,
});

export const initialRootState: RootState = {
  todo: initialTodoState,
  user: initialUserState,
};

export function createStore(initialState: RootState = initialRootState): AppStore {
  return reduxCreateStore(
    reducers,
    initialState,
    composeWithDevTools(applyMiddleware()),
  );
}
