import {
  createStore as reduxCreateStore,
  combineReducers,
  applyMiddleware,
  Store,
} from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import articleReducer, { ArticleState, initialArticleState } from './reducers/articleReducer';
import countReducer, { CountState, initialCountState } from './reducers/countReducer';

export type RootState = {
  count: CountState,
  article: ArticleState,
};

export type AppStore = Store<RootState>;

const reducers = combineReducers({
  count: countReducer,
  article: articleReducer,
});

export const initialRootState: RootState = {
  count: initialCountState,
  article: initialArticleState,
};

export function createStore(initialState: RootState = initialRootState): AppStore {
  return reduxCreateStore(
    reducers,
    initialState,
    composeWithDevTools(applyMiddleware()),
  );
}
