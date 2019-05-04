import App, { Container } from 'next/app';
import React from 'react';
import withRedux, { AppProps } from '../lib/withRedux';
import { Provider } from 'react-redux';

class MyApp extends App<AppProps> {
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
