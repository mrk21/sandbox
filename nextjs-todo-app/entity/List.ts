import InvalidValueError from '~/lib/InvalidValueError';
import { isNotNullType } from '~/lib/typeHelpers';

export type List<T> = Array<T>;

export type Specialization<T> = {
  fromObject: (value: unknown) => T;
};

export const fromObject = <T>(specialized: Specialization<T>) => (value: unknown): List<T> => {
  if (!isNotNullType(value, Array)) throw new InvalidValueError('list', value);
  return value.map(specialized.fromObject);
};

export const specialize = <T>(specialized: Specialization<T>) => ({
  fromObject: (value: unknown) => fromObject(specialized)(value),
});
