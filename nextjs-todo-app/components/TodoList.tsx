import React from 'react';
import { connect } from 'react-redux';
import Link from 'next/link';
import { Todo } from '~/entity/Todo';
import * as todo from '~/reducers/todoReducer';
import * as types from '~/lib/ComponentTypes';
import Assigner from '~/components/Assigner';

type PropsTypes = types.PropsTypes & {
  Owned: {
    detailLinkProps: (id: string) => {
      href: string;
      as?: string;
    };
  };
  State: {
    records: Todo[];
    isLoadingAll: boolean;
  };
};
type CTypes = types.ComponentTypes<PropsTypes>;

export const TodoList: CTypes['FunctionComponent'] = ({ detailLinkProps, isLoadingAll, records }) => {
  if (isLoadingAll) {
    return (<div>loading...</div>);
  }
  return (
    <>
      { records.map((record) => (
        <div className="todo-list__item" key={ record.id }>
          <p>id: { record.id }</p>
          <p>title: { record.title }</p>
          <Assigner id={ record.assignerId }></Assigner>
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

const mapStateToProps: CTypes['MapStateToPropsFunc'] = (state) => ({
  records: todo.records(state),
  isLoadingAll: todo.isLoadingAll(state),
});

const mapDispatchToProps: CTypes['MapDispatchToPropsFunc'] = () => ({});

export default connect(mapStateToProps, mapDispatchToProps)(TodoList);
