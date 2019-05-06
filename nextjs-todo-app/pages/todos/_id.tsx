import { connect, MapStateToProps, MapDispatchToPropsFunction } from 'react-redux';
import { RootState } from '~/store';
import { StatelessPageComponent } from '~/lib/withRedux';
import { getTodo } from '~/actions/todoActions';
import isServer from '~/lib/isServer';
import InvalidValueError from '~/lib/InvalidValueError';
import DefaultLayout from '~/components/layouts/DefaultLayout';
import TodoDetail from '~/components/TodoDetail';

type TodoDetailPagePropsFromNext = {
  id: string
};
type TodoDetailPagePropsFromState = {};
type TodoDetailPagePropsFromAction = {
  getTodo: (input: { id: string }) => Promise<void>;
};
type TodoDetailPageProps =
  TodoDetailPagePropsFromNext &
  TodoDetailPagePropsFromState &
  TodoDetailPagePropsFromAction;
type Component = StatelessPageComponent<
  TodoDetailPageProps,
  TodoDetailPagePropsFromNext
>;
type ComponentMapStateToProps = MapStateToProps<
  TodoDetailPagePropsFromState,
  TodoDetailPagePropsFromNext,
  RootState
>;
type ComponentMapDispatchToProps = MapDispatchToPropsFunction<
  TodoDetailPagePropsFromAction,
  TodoDetailPagePropsFromNext
>;

export const TodoDetailPage: Component = ({ id }) => {
  return (
    <DefaultLayout>
      <h2>Todo#{ id }</h2>
      <TodoDetail id={ id }></TodoDetail>
    </DefaultLayout>
  );
};
TodoDetailPage.getInitialProps = async (context) => {
  const { id } = context.query;
  if (typeof id !== 'string') throw new InvalidValueError('TodoDetailPage id', id);
  const actions = mapDispatchToProps(context.store.dispatch, { id });

  if (isServer) {
    await actions.getTodo({ id });
  }
  else {
    actions.getTodo({ id });
  }
  return { id };
};

const mapStateToProps: ComponentMapStateToProps = () => ({});
const mapDispatchToProps: ComponentMapDispatchToProps = (dispatch) => ({
  getTodo: (input) => getTodo(dispatch, input),
});

export default connect(mapStateToProps, mapDispatchToProps)(TodoDetailPage);
