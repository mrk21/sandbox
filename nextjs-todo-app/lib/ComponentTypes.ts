import React from 'react';
import { MapStateToProps, MapDispatchToPropsFunction, MergeProps } from 'react-redux';
import { RootState } from '~/store';
import { NextContextWithRedux } from '~/lib/withRedux';
import { DefaultQuery } from 'next/router';

export type PropsTypes = {
  Owned: {};
  Page: {};
  State: {};
  Dispatch: {};
  Merge: {};
};

export type Props<P extends PropsTypes = PropsTypes> = P['Owned'] & P['Page'] & P['State'] & P['Dispatch'] & P['Merge'];

export type ComponentTypes<P extends PropsTypes = PropsTypes, Q extends DefaultQuery = DefaultQuery> = {
  Props: Props<P>;
  StatelessComponent: React.StatelessComponent<Props<P>>;
  StatelessPageComponent: React.StatelessComponent<Props<P>> & {
    getInitialProps?: (context: NextContextWithRedux<Q>) => Promise<P['Page']>
  };
  MapStateToPropsFunc: MapStateToProps<P['State'], P['Owned'] & P['Page'], RootState>;
  MapDispatchToPropsFunc: MapDispatchToPropsFunction<P['Dispatch'], P['Owned'] & P['Page']>;
  MergeProps: MergeProps<P['State'], P['Dispatch'], P['Owned'] & P['Page'], P['Merge']>;
};
