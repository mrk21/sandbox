import { connect } from 'react-redux';
import * as types from '~/lib/ComponentTypes';
import isServer from '~/lib/isServer';
import { getTodo } from '~/actions/todoActions';
import DefaultLayout from '~/components/layouts/DefaultLayout';
import TodoDetail from '~/components/TodoDetail';

type PropsTypes = types.PropsTypes & {
  Owned: {
    id: string;
  }
  Page: {
    id: string;
  };
  Dispatch: {
    getTodo: (input: { id: string }) => Promise<void>;
  };
};
type Query = {
  id: string;
}
type CTypes = types.ComponentTypes<PropsTypes, Query>;

export const TodoDetailPage: CTypes['StatelessPageComponent'] = ({ id }) => {
  return (
    <DefaultLayout>
      <h2>Todo#{ id }</h2>
      <TodoDetail id={ id }></TodoDetail>
    </DefaultLayout>
  );
};
TodoDetailPage.getInitialProps = async (context) => {
  const { id } = context.query;
  const actions = mapDispatchToProps(context.store.dispatch, { id });

  if (isServer) {
    await actions.getTodo({ id });
  }
  else {
    actions.getTodo({ id });
  }
  return { id };
};

const mapStateToProps: CTypes['MapStateToPropsFunc'] = () => ({});
const mapDispatchToProps: CTypes['MapDispatchToPropsFunc'] = (dispatch) => ({
  getTodo: (input) => getTodo(dispatch, input),
});

export default connect(mapStateToProps, mapDispatchToProps)(TodoDetailPage);
