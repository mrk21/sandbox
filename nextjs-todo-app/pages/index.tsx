import { connect, MapStateToProps, MapDispatchToPropsFunction } from 'react-redux';
import { RootState } from '~/store';
import { StatelessPageComponent } from '~/lib/withRedux';
import DefaultLayout from '~/components/layouts/DefaultLayout';
import { getTodoList } from '~/actions/todoActions';
import TodoList from '~/components/TodoList';
import isServer from '~/lib/isServer';

type IndexPagePropsFromNext = {};
type IndexPagePropsFromState = {};
type IndexPagePropsFromAction = {
  getTodoList: () => Promise<void>;
};
type IndexPageProps =
  IndexPagePropsFromNext &
  IndexPagePropsFromState &
  IndexPagePropsFromAction;
type Component = StatelessPageComponent<IndexPageProps, IndexPagePropsFromNext>;
type ComponentMapStateToProps = MapStateToProps<
  IndexPagePropsFromState,
  IndexPagePropsFromNext,
  RootState
>;
type ComponentMapDispatchToProps = MapDispatchToPropsFunction<
  IndexPagePropsFromAction,
  IndexPagePropsFromNext
>;

export const IndexPage: Component = () => (
  <DefaultLayout>
    <h2>Home</h2>
    <TodoList detailLinkProps={ (id) => ({
      href: `/todos/_id?id=${id}`,
      as: `/todos/${id}`,
    }) }></TodoList>
  </DefaultLayout>
);
IndexPage.getInitialProps = async (context) => {
  const actions = mapDispatchToProps(context.store.dispatch, {});

  if (isServer) {
    await actions.getTodoList();
  }
  else {
    actions.getTodoList();
  }
  return {};
};
const mapStateToProps: ComponentMapStateToProps = () => ({});
const mapDispatchToProps: ComponentMapDispatchToProps = (dispatch) => ({
  getTodoList: () => getTodoList(dispatch),
});

export default connect(mapStateToProps, mapDispatchToProps)(IndexPage);
