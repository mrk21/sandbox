import { StatelessComponent } from 'react';
import { connect, MapStateToProps, MapDispatchToPropsFunction } from 'react-redux';
import { RootState } from '~/store';
import { Todo } from '~/entity/Todo';
import { APIError } from '~/entity/APIError';
import * as todoReducer from '~/reducers/todoReducer';
import InvalidValueError from '~/lib/InvalidValueError';

type TodoDetailPropsFromParent = {
  id: string;
}

type TodoDetailPropsFromState = {
  record: Todo | undefined;
  error: APIError | undefined;
  isLoading: boolean;
};

type TodoDetailPropsFromAction = {};

type TodoDetailProps = TodoDetailPropsFromParent & TodoDetailPropsFromState & TodoDetailPropsFromAction;

export const TodoDetail: StatelessComponent<TodoDetailProps> = ({ id, record, error, isLoading }) => {
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

const mapStateToProps: MapStateToProps<TodoDetailPropsFromState, TodoDetailPropsFromParent, RootState> = (state, { id }) => ({
  record: todoReducer.record(state, id),
  error: todoReducer.error(state, id),
  isLoading: todoReducer.isLoading(state, id),
});

const mapDispatchToProps: MapDispatchToPropsFunction<TodoDetailPropsFromAction, TodoDetailPropsFromParent> = () => ({});

export default connect(mapStateToProps, mapDispatchToProps)(TodoDetail);
