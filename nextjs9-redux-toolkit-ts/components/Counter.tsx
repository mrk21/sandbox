import React, { FC } from 'react';
import { useAppSelector, useAppDispatch } from '@/hooks';
import { increment, decrement, incrementBy, incrementByAsync } from '@/modules/counter';

export type CounterProps = {
  amount: number;
};

const Counter: FC<CounterProps> = ({ amount }) => {
  const count = useAppSelector(state => state.counter.value);
  const dispatch = useAppDispatch();
  return (
    <>
      <p>{count}</p>
      <button
        aria-label="Increment value"
        onClick={() => dispatch(increment())}
      >+</button>
      <button
        aria-label="Decrement value"
        onClick={() => dispatch(decrement())}
      >-</button>
      <button
        aria-label="Increment value"
        onClick={() => dispatch(incrementBy(amount))}
      >+{amount}</button>
      <button
        aria-label="Async increment value"
        onClick={() => dispatch(incrementByAsync(amount))}
      >+{amount}(async)</button>
    </>
  );
};

export default Counter;
