import { Action } from 'redux';

export enum ArticleActionTypes {
  CREATE = 'Article/CREATE',
};

export type CreateArticleAction = Action<ArticleActionTypes.CREATE> & {
  payload: any;
};

export type ArticleAction = CreateArticleAction;

export function createArticle(payload: any) : CreateArticleAction {
  return {
    type: ArticleActionTypes.CREATE,
    payload,
  };
}
