import { FC } from 'react';
import { AppProps } from 'next/app'
import { wrapper } from '@/store'

const App: FC<AppProps> = ({ Component, pageProps }) => (
  <Component {...pageProps} />
);

export default wrapper.withRedux(App);
