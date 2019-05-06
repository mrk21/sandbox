import App, { Container } from 'next/app';
import React from 'react';
import withRedux, { ReduxContext } from '../lib/withRedux';
import { Provider } from 'react-redux';

class MyApp extends App<ReduxContext> {
  render() {
    const { Component, pageProps, store } = this.props;
    return (
      <Container>
        <Provider store={ store }>
          <Component {...pageProps} />
        </Provider>
      </Container>
    )
  };
}

export default withRedux(MyApp);
