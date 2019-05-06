import React from 'react'
import { createStore, RootState, initialRootState, AppStore } from '../store'
import { NextContext } from 'next';
import { DefaultQuery } from 'next/router';
import { AppComponentType, NextAppContext, DefaultAppIProps } from 'next/app';

export const isServer = typeof window === 'undefined';

export type ReduxContext = {
  store: AppStore;
};

export type NextContextWithRedux<Q extends DefaultQuery = DefaultQuery> =
  NextContext<Q> & ReduxContext;

export type NextAppContextWithRedux<Q extends DefaultQuery = DefaultQuery> =
  NextAppContext<Q> & {
    ctx: NextContextWithRedux<Q>;
  };

export type AppWithReduxProps = DefaultAppIProps & {
  initialState: RootState;
};

export type GetInitialProps<P extends {} = {}, Q extends DefaultQuery = DefaultQuery> =
  (context: NextContextWithRedux<Q>) => Promise<P>;

export type GetAppWithReduxInitialProps<Q extends DefaultQuery = DefaultQuery> =
  (context: NextAppContextWithRedux<Q>) => Promise<AppWithReduxProps>;

let store: AppStore | null = null;

function getOrCreateStore(initialState: RootState = initialRootState): AppStore {
  if (isServer) {
    return createStore(initialState);
  }
  if (store === null) {
    store = createStore(initialState);
  }
  return store;
}

export const withRedux = (App: AppComponentType<any>) => {
  const AppWithRedux = (props: AppWithReduxProps) => {
    const store = getOrCreateStore(props.initialState);
    return (<App {...props} store={ store } />);
  };

  const getInitialProps: GetAppWithReduxInitialProps = async (context) => {
    const store = getOrCreateStore();
    context.ctx.store = store;

    let appProps: DefaultAppIProps | null = null;
    if (typeof App.getInitialProps !== 'function') throw new Error('invalid app component!');
    appProps = await App.getInitialProps(context);
    if (appProps === null) throw new Error('invalid app props!');

    return {
      ...appProps,
      initialState: store.getState(),
    };
  };

  AppWithRedux.getInitialProps = getInitialProps;
  return AppWithRedux;
};

export default withRedux;
