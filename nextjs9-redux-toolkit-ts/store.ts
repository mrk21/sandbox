import { configureStore, ThunkAction, Action } from '@reduxjs/toolkit';
import { createWrapper } from "next-redux-wrapper";
import { RootState, rootReducer } from '@/modules/root';
import { CreateWrapper } from '@/types/CreateWrappter';

export type AppStore = ReturnType<typeof makeStore>;
export type AppDispatch = AppStore['dispatch'];
export type AppThunkAction<Return = void> = ThunkAction<
  Promise<Return>,
  RootState,
  unknown,
  Action<string>
>;

export const makeStore = () => (
  configureStore({
    reducer: rootReducer,
    devTools: true,
  })
);

export const wrapper = (<CreateWrapper<AppStore>>createWrapper)((_) => makeStore());
