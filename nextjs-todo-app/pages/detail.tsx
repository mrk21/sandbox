import { connect, MapStateToProps, MapDispatchToPropsFunction } from 'react-redux';
import { RootState } from '~/store';
import { GetInitialProps } from '~/lib/withRedux';
import { Todo } from '~/entity/Todo';
import { getTodo, makeTodo } from '~/actions/todoActions';
import { APIError } from '~/entity/APIError';
import isServer from '~/lib/isServer';
import { record as todoRecord, error as todoError, isLoading as isLoadingTodo } from '~/reducers/todoReducer';
import InvalidValueError from '@/lib/InvalidValueError';

type DetailPropsFromNext = {
  id: string;
};

type DetailPropsFromState = {
  record: Todo | undefined;
  error: APIError | undefined;
  isLoading: boolean | undefined;
};

type DetailPropsFromAction = {
  getTodo: (input: { id: string }) => Promise<void>;
  makeTodo: (input: Partial<Todo>) => Promise<string>;
};

type DetailProps = DetailPropsFromNext & DetailPropsFromState & DetailPropsFromAction;

export const Detail = ({ id, record, error, isLoading }: DetailProps) => {
  if (isLoading) {
    return (<div>loading...</div>);
  }

  if (record) {
    return (
      <div>
        <p>detail: { id }</p>
        <p>{ record.title }</p>
        <p>{ record.description }</p>
      </div>
    );
  }
  else if (error) {
    return (
      <div>
        <p>detail: { id }</p>
        { error.messages.map((message, i) => (
          <p key={i}>{ message }</p>
        )) }
      </div>
    );
  }
  else {
    throw new InvalidValueError('props', { record, error });
  }
};

const getInitialProps: GetInitialProps<DetailPropsFromNext> = async (context) => {
  const { id } = context.query;
  if (typeof id !== 'string') throw new InvalidValueError('detail id', id);
  const actions = mapDispatchToProps(context.store.dispatch, { id });

  if (id === '0') {
    const newId = await actions.makeTodo({ title: 'new title' });
    return { id: newId };
  }
  else {
    if (isServer) {
      await actions.getTodo({ id });
    }
    else {
      actions.getTodo({ id });
    }
    return { id };
  }
};

const mapStateToProps: MapStateToProps<DetailPropsFromState, DetailPropsFromNext, RootState> = (state, ownProps) => ({
  record: todoRecord(state, ownProps.id),
  error: todoError(state, ownProps.id),
  isLoading: isLoadingTodo(state, ownProps.id),
});

const mapDispatchToProps: MapDispatchToPropsFunction<DetailPropsFromAction, DetailPropsFromNext> = (dispatch) => ({
  getTodo: (input) => getTodo(dispatch, input),
  makeTodo: (input) => makeTodo(dispatch, input),
});

Detail.getInitialProps = getInitialProps;
export default connect(mapStateToProps, mapDispatchToProps)(Detail);
