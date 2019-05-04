import { Model, attr } from 'redux-orm';

export type Article = {
  id: string | null;
  title: string;
};

export class ArticleModel extends Model<Article> {
  toString() {
    return `Article: ${this.getId()}`;
  }
}
ArticleModel.modelName = 'Article';
ArticleModel.fields = {
  id: attr(),
  title: attr(),
};
