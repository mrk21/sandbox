import InvalidValueError from '~/lib/InvalidValueError';
import { PropertyHolder, isNullableType, isNotNullType, isNull } from '~/lib/typeHelpers';
import { APIError, fromObject as fromObjectForError } from '~/entity/APIError';

export type APIResponse<T> = {
  data: T | null;
  error: APIError | null;
};

type Option<T> = {
  fromObjectForData: (value: unknown) => T;
};

export function fromObject<T>(value: unknown, option: Option<T>): APIResponse<T> {
  if (!isNotNullType(value, 'object')) throw new InvalidValueError('object', value);

  const object: PropertyHolder<APIResponse<T>> = value;

  if (!isNullableType(object.data , 'object')) throw new InvalidValueError('object.data' , object.data );
  if (!isNullableType(object.error, 'object')) throw new InvalidValueError('object.error', object.error);

  const data = isNull(object.data) ? null : option.fromObjectForData(object.data);
  const error = isNull(object.error) ? null : fromObjectForError(object.error);

  return { data, error };
}

export default <T>(option: Option<T>) => ({
  fromObject: (value: unknown) => fromObject(value, option),
});
