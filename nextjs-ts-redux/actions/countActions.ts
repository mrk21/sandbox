export enum CountAction {
  INCREMENT = 'Count/INCREMENT',
  DECREMENT = 'Count/DECREMENT',
};

export function incrementCount() {
  return {
    type: CountAction.INCREMENT
  };
}

export function decrementCount() {
  return {
    type: CountAction.DECREMENT
  };
}
