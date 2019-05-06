import { StatelessComponent } from 'react';
import { connect, MapStateToProps, MapDispatchToPropsFunction } from 'react-redux';
import { RootState } from '~/store';
import { Todo } from '~/entity/Todo';
import * as todoReducer from '~/reducers/todoReducer';
import Link from 'next/link';

type TodoListPropsFromParent = {
  detailLinkProps: (id: string) => {
    href: string;
    as?: string;
  }
}
type TodoListPropsFromState = {
  records: Todo[];
  isLoadingAll: boolean;
};
type TodoListPropsFromAction = {};
type TodoListProps =
  TodoListPropsFromParent &
  TodoListPropsFromState &
  TodoListPropsFromAction;
type Component = StatelessComponent<TodoListProps>;
type ComponentMapStateToProps = MapStateToProps<
  TodoListPropsFromState,
  TodoListPropsFromParent,
  RootState
>;
type ComponentMapDispatchToProps = MapDispatchToPropsFunction<
  TodoListPropsFromAction,
  TodoListPropsFromParent
>;

export const TodoList: Component = ({ detailLinkProps, isLoadingAll, records }) => {
  if (isLoadingAll) {
    return (<div>loading...</div>);
  }
  return (
    <>
      { records.map((record) => (
        <div className="todo-list__item" key={ record.id }>
          <p>id: { record.id }</p>
          <p>title: { record.title }</p>
          <Link { ...detailLinkProps(record.id) }>
            <a>detail</a>
          </Link>
        </div>
      )) }
      <style jsx>{`
        .todo-list__item {
          display: block;
          border: 1px solid #ccc;
          padding: 10px;
          margin-bottom: 5px;
        }
      `}</style>
    </>
  );
};
const mapStateToProps: ComponentMapStateToProps = (state) => ({
  records: todoReducer.records(state),
  isLoadingAll: todoReducer.isLoadingAll(state),
});
const mapDispatchToProps: ComponentMapDispatchToProps = () => ({});

export default connect(mapStateToProps, mapDispatchToProps)(TodoList);
