import isServer from '~/lib/isServer';
import * as types from '~/lib/ComponentTypes';
import { getTodoList } from '~/actions/todoActions';
import DefaultLayout from '~/components/layouts/DefaultLayout';
import TodoList from '~/components/TodoList';

type PropsTypes = types.PropsTypes & {};
type CTypes = types.ComponentTypes<PropsTypes>;

export const IndexPage: CTypes['PageFunctionComponent'] = () => (
  <DefaultLayout>
    <h2>Home</h2>
    <TodoList detailLinkProps={ (id) => ({
      href: `/todos/_id?id=${id}`,
      as: `/todos/${id}`,
    }) }></TodoList>
  </DefaultLayout>
);

IndexPage.getInitialProps = async (context) => {
  if (isServer) {
    await getTodoList(context.store.dispatch, { includes: { assigner: true } });
  }
  else {
    getTodoList(context.store.dispatch, { includes: { assigner: true } }).then((a) => { console.log(`### fetched 1: ${a}`); });
    getTodoList(context.store.dispatch, { includes: { assigner: true } }).then((a) => { console.log(`### fetched 2: ${a}`); });
    getTodoList(context.store.dispatch, { includes: { assigner: true } }).then((a) => { console.log(`### fetched 3: ${a}`); });
    getTodoList(context.store.dispatch, { includes: { assigner: true } }).then((a) => { console.log(`### fetched 4: ${a}`); });
    getTodoList(context.store.dispatch, { includes: { assigner: true } }).then((a) => { console.log(`### fetched 5: ${a}`); });
  }
  return {};
};

export default IndexPage;
