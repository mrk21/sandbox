import React from 'react'
import { createStore, RootState, initialRootState, AppStore } from '../store'
import { NextContext } from 'next';
import { NextDocumentContext } from 'next/document';
import { DefaultQuery } from 'next/router';
import { AppComponentType, NextAppContext, DefaultAppIProps } from 'next/app';

const isServer = typeof window === 'undefined'

export type AppWithReduxProps = DefaultAppIProps & {
  initialState: RootState;
};

export type AppProps = {
  store: AppStore;
  isServer: boolean;
};

export type NextReduxContext = {
  store: AppStore;
  isServer: boolean;
};

export type NextReduxAppContext<Q extends DefaultQuery = DefaultQuery> = {
  ctx: NextContext<Q> & NextReduxContext;
};

export type GetInitialProps<P extends {} = {}, Q extends DefaultQuery = DefaultQuery>
  = (context: NextDocumentContext<Q> & NextReduxContext) => Promise<P>;

export type GetAppWithReduxInitialProps<Q extends DefaultQuery = DefaultQuery>
  = (context: NextAppContext<Q> & NextReduxAppContext) => Promise<AppWithReduxProps>;

function getOrCreateStore(initialState: RootState = initialRootState): AppStore {
  // Always make a new store if server, otherwise state is shared between requests
  if (isServer) {
    return createStore(initialState)
  }
  const window_: Window & { __NEXT_REDUX_STORE__?: AppStore } = window;

  // Create store if unavailable on the client and set it on the window object
  if (typeof window_.__NEXT_REDUX_STORE__ === 'undefined') {
    window_.__NEXT_REDUX_STORE__ = createStore(initialState);
  }
  return window_.__NEXT_REDUX_STORE__;
}

export const withRedux = (App: AppComponentType<any>) => {
  const AppWithRedux = (props: AppWithReduxProps) => {
    const store = getOrCreateStore(props.initialState);
    return <App {...props} store={ store } isServer={ isServer } />
  };

  const getInitialProps: GetAppWithReduxInitialProps = async (context) => {
    // Get or Create the store with `undefined` as initialState
    // This allows you to set a custom default initialState
    const store = getOrCreateStore();

    // Provide the store to getInitialProps of pages
    context.ctx.store = store;
    context.ctx.isServer = isServer;

    let appProps: DefaultAppIProps | null = null;
    if (typeof App.getInitialProps !== 'function') throw new Error('invalid component!');
    appProps = await App.getInitialProps(context);
    if (appProps === null) throw new Error('invalid props!');

    return {
      ...appProps,
      initialState: store.getState(),
    };
  };

  AppWithRedux.getInitialProps = getInitialProps;
  return AppWithRedux;
};

export default withRedux;
