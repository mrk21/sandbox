export function makeTuple<T extends unknown[]>(...v: [...T]) {
  return v;
}
