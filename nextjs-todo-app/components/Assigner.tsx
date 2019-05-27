import React from 'react';
import { connect } from 'react-redux';
import * as user from '~/reducers/userReducer';
import * as types from '~/lib/ComponentTypes';
import { isNull } from '~/lib/typeHelpers';
import { User } from '~/entity/User';

type PropsTypes = types.PropsTypes & {
  Owned: {
    id: string | null;
  };
  State: {
    user: User | undefined;
    isLoading: boolean;
  };
};
type CTypes = types.ComponentTypes<PropsTypes>;

export const Assigner: CTypes['FunctionComponent'] = ({ id, user, isLoading }) => {
  if (isNull(id)) {
    return (<p>-</p>);
  }
  if (isLoading) {
    return (<p>loading...</p>);
  }
  if (user) {
    return (<p>assigner: { user.name }</p>);
  }
  return (<p>-</p>);
};

const mapStateToProps: CTypes['MapStateToPropsFunc'] = (state, { id }) => ({
  user: id ? user.record(state, id) : undefined,
  isLoading: id ? user.isLoading(state, id) : false,
});

const mapDispatchToProps: CTypes['MapDispatchToPropsFunc'] = () => ({});

export default connect(mapStateToProps, mapDispatchToProps)(Assigner);
