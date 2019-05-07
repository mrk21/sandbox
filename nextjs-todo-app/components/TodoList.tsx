import React from 'react';
import { connect } from 'react-redux';
import Link from 'next/link';
import { Todo } from '~/entity/Todo';
import * as todo from '~/reducers/todoReducer';
import * as user from '~/reducers/userReducer';
import * as types from '~/lib/ComponentTypes';
import { User } from '~/entity/User';
import { isNull } from '@/lib/typeHelpers';

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
    userRecord: (id: string) => User;
    isLoadingUser: (id: string) => boolean;
  };
};
type CTypes = types.ComponentTypes<PropsTypes>;

export const TodoList: CTypes['StatelessComponent'] = ({ detailLinkProps, isLoadingAll, records, isLoadingUser, userRecord }) => {
  if (isLoadingAll) {
    return (<div>loading...</div>);
  }

  const Assigner: React.StatelessComponent<{ id: string | null }> = ({ id }) => {
    if (isNull(id)) {
      return (<p>-</p>);
    }
    if (isLoadingUser(id)) {
      return (<p>loading...</p>);
    }
    const user = userRecord(id);
    if (user) {
      return (<p>assigner: { user.name }</p>);
    }
    return (<p>-</p>);
  };

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
  userRecord: (id) => user.record(state, id),
  isLoadingUser: (id) => user.isLoading(state, id),
});

const mapDispatchToProps: CTypes['MapDispatchToPropsFunc'] = () => ({});

export default connect(mapStateToProps, mapDispatchToProps)(TodoList);
