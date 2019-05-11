import { connect } from 'react-redux';
import isServer from '~/lib/isServer';
import * as types from '~/lib/ComponentTypes';
import { getTodoList } from '~/actions/todoActions';
import DefaultLayout from '~/components/layouts/DefaultLayout';
import TodoList from '~/components/TodoList';

type PropsTypes = types.PropsTypes & {
  Dispatch: {
    getTodoList: () => Promise<void>;
  };
};
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
    await getTodoList(context.store.dispatch);
  }
  else {
    getTodoList(context.store.dispatch);
  }
  return {};
};

const mapStateToProps: CTypes['MapStateToPropsFunc'] = () => ({});
const mapDispatchToProps: CTypes['MapDispatchToPropsFunc'] = (dispatch) => ({
  getTodoList: () => getTodoList(dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(IndexPage);
