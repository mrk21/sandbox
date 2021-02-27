import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import { AppThunkAction } from '@/store';

export type CounterState = {
  value: number;
};

const initialState: CounterState = {
  value: 0
};

const counterSlice = createSlice({
  name: 'counter',
  initialState,
  reducers: {
    increment(state) {
      state.value += 1;
    },
    decrement(state) {
      state.value -= 1;
    },
    incrementBy(state, { payload }: PayloadAction<number>) {
      state.value += payload;
    },
  }
});

export const counterReducer = counterSlice.reducer;

export const { increment, decrement, incrementBy } = counterSlice.actions;

export const incrementByAsync = (amount: number): AppThunkAction => async (dispatch) => (
  new Promise(resolve => {
    setTimeout(() => {
      dispatch(incrementBy(amount));
      resolve();
    }, 1000);
  })
);
