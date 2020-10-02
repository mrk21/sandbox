import React from 'react';
import { NextPage } from 'next'
import Head from 'next/head'
import { wrapper } from '@/store';
import { useAppDispatch } from '@/hooks';
import { increment, incrementByAsync } from '@/modules/counter';
import { useDidMount } from '@/hooks';
import Counter from '@/components/Counter';

const IndexPage: NextPage = () => {
  const dispatch = useAppDispatch();
  useDidMount(() => { dispatch(increment()); });
  return (
    <div>
      <Head>
        <title>Hello</title>
        <meta name="viewport" content="initial-scale=1.0, width=device-width" />
      </Head>
      <h1>Hello Next.js 👋</h1>
      <Counter amount={13} />
    </div>
  );
};

export const getServerSideProps = wrapper.getServerSideProps(
  async ({ store }) => {
    await store.dispatch(incrementByAsync(100));
  }
);

export default IndexPage;
