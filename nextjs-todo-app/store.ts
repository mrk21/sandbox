import {
  createStore as reduxCreateStore,
  combineReducers,
  applyMiddleware,
  Store,
  Dispatch,
} from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import todoReducer, { TodoState, initialTodoState } from './reducers/todoReducer';
import userReducer, { UserState, initialUserState } from './reducers/userReducer';
import { TodoActionTree } from './actions/todoActions';
import { UserActionTree } from './actions/userActions';
import { Actions } from '~/lib/reduxTypes';

export type RootState = {
  todo: TodoState,
  user: UserState,
};
export type AppActions = Actions<[
  TodoActionTree,
  UserActionTree,
]>;
export type AppStore = Store<RootState, AppActions>;
export type AppDispatch = Dispatch<AppActions>;

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
