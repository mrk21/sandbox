import { Reducer, Action } from 'redux';
import { CountAction } from '../actions/countActions';

export type CountState = {
  count: number;
};

export type CountReducer = Reducer<CountState, Action<CountAction>>;

export const initialCountState: CountState = {
  count: 0,
};

export const countReducer: CountReducer = (state = initialCountState, action) => {
  switch (action.type) {
    case CountAction.INCREMENT:
      return {
        ...state,
        count: state.count + 1,
      };
    case CountAction.DECREMENT:
      return {
        ...state,
        count: state.count - 1,
      };
    default:
      return state;
  }
}

export default countReducer;
