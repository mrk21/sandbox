import InvalidValueError from '~/lib/InvalidValueError';
import { PropertyHolder, isNotNullType } from '~/lib/typeHelpers';
import * as apiResponseBase from '~/entity/APIResourceBase';
import * as objectEntity from '~/entity/ObjectEntity';

export type User = apiResponseBase.APIResourceBase & {
  name: string;
};

export function fromObject(value: unknown): User {
  const baseEntity = apiResponseBase.fromObject(value);
  const object: PropertyHolder<User> = objectEntity.fromObject(value);

  if (!isNotNullType(object.name, 'string')) throw new InvalidValueError('object.name', object.name);

  return {
    ...baseEntity,
    name: object.name,
  };
}

export function makeEntity(values: Partial<User>): User {
  return fromObject({
    ...apiResponseBase.fromObject(values),
    name: values.name || '',
  });
}
