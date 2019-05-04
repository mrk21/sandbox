import {
  createStore as reduxCreateStore,
  combineReducers,
  applyMiddleware,
  Store,
} from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import countReducer, { CountState, initialCountState } from './reducers/countReducer';

export type RootState = {
  count: CountState,
};

export type AppStore = Store<RootState>;

const reducers = combineReducers({
  count: countReducer,
});

export const initialRootState: RootState = {
  count: initialCountState
};

export function createStore(initialState: RootState = initialRootState): AppStore {
  return reduxCreateStore(
    reducers,
    initialState,
    composeWithDevTools(applyMiddleware()),
  );
}
