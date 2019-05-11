import { connect } from 'react-redux';
import { Todo } from '~/entity/Todo';
import { User } from '~/entity/User';
import { APIError } from '~/entity/APIError';
import * as todo from '~/reducers/todoReducer';
import * as user from '~/reducers/userReducer';
import * as types from '~/lib/ComponentTypes';
import InvalidValueError from '~/lib/InvalidValueError';
import { isNull } from '~/lib/typeHelpers';

type PropsTypes = types.PropsTypes & {
  Owned: {
    id: string;
  };
  State: {
    record: Todo | undefined;
    error: APIError | undefined;
    isLoading: boolean;
    userRecord: User | undefined;
    isLoadingUser: boolean;
  };
};
type CTypes = types.ComponentTypes<PropsTypes>;

export const TodoDetail: CTypes['FunctionComponent'] = ({ id, record, error, isLoading, userRecord, isLoadingUser }) => {
  if (isLoading) {
    return (<div>loading...</div>);
  }

  const Assigner: React.FunctionComponent<{ id: string | null }> = ({ id }) => {
    if (isNull(id)) {
      return (<p>-</p>);
    }
    if (isLoadingUser) {
      return (<p>loading...</p>);
    }
    const user = userRecord;
    if (user) {
      return (
        <>
          <p>id: { user.id }</p>
          <p>name: { user.name }</p>
        </>
      );
    }
    return (<p>-</p>);
  };

  if (record) {
    return (
      <>
        <div className="todo-detail">
          <p>id: { id }</p>
          <p>title: { record.title }</p>
          <p>description: { record.description }</p>
        </div>

        <div className="assigner-detail">
          <div className="assigner-detail__headline">assigner</div>
          <Assigner id={ record.assignerId }></Assigner>
        </div>

        <style jsx>{`
          .todo-detail {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
          }
          .assigner-detail {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
          }
          .assigner-detail__headline {
            font-weight: bold;
            font-size: 150%;
          }
        `}</style>
      </>
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
  userRecord: user.record(state, id),
  isLoadingUser: user.isLoading(state, id),
});

const mapDispatchToProps: CTypes['MapDispatchToPropsFunc'] = () => ({});

export default connect(mapStateToProps, mapDispatchToProps)(TodoDetail);
