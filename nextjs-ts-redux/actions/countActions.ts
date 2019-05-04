import { Action } from 'redux';

export enum CountActionTypes {
  INCREMENT = 'Count/INCREMENT',
  DECREMENT = 'Count/DECREMENT',
};

export type IncrementCountAction = Action<CountActionTypes.INCREMENT> & {
  payload: {
    value: number;
  }
};

export type DecrementCountAction = Action<CountActionTypes.DECREMENT> & {
  payload: {
    value: number;
  }
};

export type CountAction = IncrementCountAction | DecrementCountAction;

export function incrementCount(value: number = 1) : IncrementCountAction {
  return {
    type: CountActionTypes.INCREMENT,
    payload: { value },
  };
}

export function decrementCount(value: number = 1) : DecrementCountAction {
  return {
    type: CountActionTypes.DECREMENT,
    payload: { value },
  };
}
