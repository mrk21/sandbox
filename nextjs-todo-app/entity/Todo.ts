import InvalidValueError from '~/lib/InvalidValueError';
import { PropertyHolder, isNotNullType, isNullableType } from '~/lib/typeHelpers';
import * as apiResponseBase from '~/entity/APIResourceBase';
import * as objectEntity from '~/entity/ObjectEntity';

export type Todo = apiResponseBase.APIResourceBase & {
  title: string;
  description: string;
  assignerId: string | null;
};

export function fromObject(value: unknown): Todo {
  const baseEntity = apiResponseBase.fromObject(value);
  const object: PropertyHolder<Todo> = objectEntity.fromObject(value);

  if (!isNotNullType (object.title      , 'string')) throw new InvalidValueError('object.title'      , object.title      );
  if (!isNotNullType (object.description, 'string')) throw new InvalidValueError('object.description', object.description);
  if (!isNullableType(object.assignerId , 'string')) throw new InvalidValueError('object.assignerId' , object.assignerId );

  return {
    ...baseEntity,
    title: object.title,
    description: object.description,
    assignerId: object.assignerId,
  };
}

export function makeEntity(values: Partial<Todo>): Todo {
  return fromObject({
    ...apiResponseBase.fromObject(values),
    title: values.title || '',
    description: values.description || '',
    assignerId: values.assignerId || null,
  });
}
