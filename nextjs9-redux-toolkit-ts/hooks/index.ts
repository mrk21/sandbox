import { useEffect, EffectCallback } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { RootState } from '@/modules/root';
import { AppDispatch } from '@/store';

export const useAppSelector = <Result>(
  selector: (state: RootState) => Result,
  equalityFn?: (left: Result, right: Result) => boolean
) => useSelector(selector, equalityFn);

export const useAppDispatch = () => useDispatch<AppDispatch>();

export const useDidMount = (callback: EffectCallback) => useEffect(callback, []);
