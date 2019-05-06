import { Reducer } from 'redux';
import { CountActionTypes, CountAction } from '../actions/countActions';

export type CountState = {
  count: number;
};

export type CountReducer = Reducer<CountState, CountAction>;

export const initialCountState: CountState = {
  count: 0,
};

export const countReducer: CountReducer = (state = initialCountState, action) => {
  switch (action.type) {
    case CountActionTypes.INCREMENT:
      return {
        ...state,
        count: state.count + action.payload.value,
      };
    case CountActionTypes.DECREMENT:
      return {
        ...state,
        count: state.count - action.payload.value,
      };
    default:
      return state;
  }
}

export default countReducer;
