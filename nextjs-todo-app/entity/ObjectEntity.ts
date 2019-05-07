import InvalidValueError from '~/lib/InvalidValueError';
import { isNotNullType } from '~/lib/typeHelpers';

export function fromObject(value: unknown): object {
  if (!isNotNullType(value, 'object')) throw new InvalidValueError('object', value);
  return value;
}
