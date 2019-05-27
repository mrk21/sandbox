import * as types from '~/lib/ComponentTypes';
import isServer from '~/lib/isServer';
import { getTodo } from '~/actions/todoActions';
import DefaultLayout from '~/components/layouts/DefaultLayout';
import TodoDetail from '~/components/TodoDetail';

type PropsTypes = types.PropsTypes & {
  Page: {
    id: string;
  };
};
type Query = {
  id: string;
}
type CTypes = types.ComponentTypes<PropsTypes, Query>;

export const TodoDetailPage: CTypes['PageFunctionComponent'] = ({ id }) => {
  return (
    <DefaultLayout>
      <h2>Todo#{ id }</h2>
      <TodoDetail id={ id }></TodoDetail>
    </DefaultLayout>
  );
};

TodoDetailPage.getInitialProps = async (context) => {
  const { id } = context.query;
  if (isServer) {
    await getTodo(context.store.dispatch, { id }, { includes: { assigner: true } })
  }
  else {
    getTodo(context.store.dispatch, { id }, { includes: { assigner: true } })
  }
  return { id };
};

export default TodoDetailPage;
