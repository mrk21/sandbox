import { connect } from 'react-redux';
import { Todo } from '~/entity/Todo';
import { APIError } from '~/entity/APIError';
import * as todo from '~/reducers/todoReducer';
import * as types from '~/lib/ComponentTypes';
import InvalidValueError from '~/lib/InvalidValueError';

type PropsTypes = types.PropsTypes & {
  Owned: {
    id: string;
  };
  State: {
    record: Todo | undefined;
    error: APIError | undefined;
    isLoading: boolean;
  };
};
type CTypes = types.ComponentTypes<PropsTypes>;

export const TodoDetail: CTypes['StatelessComponent'] = ({ id, record, error, isLoading }) => {
  if (isLoading) {
    return (<div>loading...</div>);
  }

  if (record) {
    return (
      <div>
        <p>id: { id }</p>
        <p>title: { record.title }</p>
        <p>description: { record.description }</p>
      </div>
    );
  }
  else if (error) {
    return (
      <div>
        { error.messages.map((message, i) => (
          <p key={i}>{ message }</p>
        )) }
      </div>
    );
  }
  else {
    throw new InvalidValueError('todo detail', id);
  }
};

const mapStateToProps: CTypes['MapStateToPropsFunc'] = (state, { id }) => ({
  record: todo.record(state, id),
  error: todo.error(state, id),
  isLoading: todo.isLoading(state, id),
});

const mapDispatchToProps: CTypes['MapDispatchToPropsFunc'] = () => ({});

export default connect(mapStateToProps, mapDispatchToProps)(TodoDetail);
