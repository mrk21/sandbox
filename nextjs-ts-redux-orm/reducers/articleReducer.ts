import { Reducer } from 'redux';
import { ArticleAction, ArticleActionTypes } from '../actions/articleActions';
import orm, { emptyDBState } from '../orm';

export type ArticleState = any;

export type ArticleReducer = Reducer<ArticleState, ArticleAction>;

export const initialArticleState: ArticleState = emptyDBState;

export const articleReducer: ArticleReducer = (state = initialArticleState, action) => {
  const session = orm.session(state);

  switch (action.type) {
    case ArticleActionTypes.CREATE:
      session.Article.create(action.payload);
      return session.state;
    default:
      return session.state;
  }
}

export default articleReducer;
