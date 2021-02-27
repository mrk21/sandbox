import React from 'react';
import { Store, AnyAction } from 'redux';
import { GetServerSidePropsContext, GetStaticPropsContext, WrapperProps, Config, Context } from "next-redux-wrapper";
import { GetServerSideProps, GetStaticProps, NextPageContext } from 'next';
import { ParsedUrlQuery } from 'querystring';

// HACK: Override types of `createWrapper`, because the `Store` type is not correct
// @see https://github.com/kirill-konshin/next-redux-wrapper/pull/247
// @example
//  export const wrapper = (<CreateWrapper<AppStore>>createWrapper)((_) => makeStore());
export type CreateWrapper<TStore extends Store> = (
  makeStore: (context: Context) => TStore,
  config?: Config<ReturnType<TStore['getState']>>
) => {
  getServerSideProps: <P extends {} = any>(
    callback: (context: GetServerSidePropsContext & { store: TStore; }) => void | P
  ) => GetServerSideProps<P, ParsedUrlQuery>;

  getStaticProps: <P_1 extends {} = any>(
    callback: (context: GetStaticPropsContext & { store: TStore; }) => void | P_1
  ) => GetStaticProps<P_1, ParsedUrlQuery>;

  withRedux: (Component: any) => React.FunctionComponent<WrapperProps> & {
    getInitialProps?(context: NextPageContext<any, AnyAction>): WrapperProps | Promise<WrapperProps>;
  };
};
