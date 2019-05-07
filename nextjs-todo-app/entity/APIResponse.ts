import InvalidValueError from '~/lib/InvalidValueError';
import { PropertyHolder, isNullableType, isNull } from '~/lib/typeHelpers';
import * as apiError from '~/entity/APIError';
import * as objectEntity from '~/entity/ObjectEntity';

type APIError = apiError.APIError;

export type APIResponse<T> = {
  data: T | null;
  error: APIError | null;
};

export type Specialization<T> = {
  data: {
    fromObject: (value: unknown) => T;
  };
};

export const fromObject = <T>(specialized: Specialization<T>) => (value: unknown): APIResponse<T> => {
  const object: PropertyHolder<APIResponse<T>> = objectEntity.fromObject(value);

  if (!isNullableType(object.data , 'object')) throw new InvalidValueError('object.data' , object.data );
  if (!isNullableType(object.error, 'object')) throw new InvalidValueError('object.error', object.error);

  const data = isNull(object.data) ? null : specialized.data.fromObject(object.data);
  const error = isNull(object.error) ? null : apiError.fromObject(object.error);

  return { data, error };
};

export const specialize = <T>(specialized: Specialization<T>) => ({
  fromObject: (value: unknown) => fromObject(specialized)(value),
});
