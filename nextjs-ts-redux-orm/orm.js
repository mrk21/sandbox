import { ORM } from 'redux-orm';
import { ArticleModel } from './models/articles';

const orm = new ORM();
orm.register(ArticleModel);

export const emptyDBState = orm.getEmptyState();
export const session = orm.session(emptyDBState);

export default orm;
