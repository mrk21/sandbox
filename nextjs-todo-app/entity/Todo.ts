import InvalidValueError from '~/lib/InvalidValueError';
import { PropertyHolder, isNullableType, isNotNullType, isOptionalType, isNull, isUndefined } from '~/lib/typeHelpers';
import uniqueId from '~/lib/uniqueId';

export type Todo = {
  readonly _newRecord: boolean;
  id: string;
  title: string;
  description: string;
};

export function fromObject(value: unknown): Todo {
  if (!isNotNullType(value, 'object')) throw new InvalidValueError('object', value);

  const object: PropertyHolder<Todo> = value;

  if (!isOptionalType(object._newRecord , 'boolean')) throw new InvalidValueError('object._newRecord' , object._newRecord );
  if (!isNullableType(object.id         , 'string' )) throw new InvalidValueError('object.id'         , object.id         );
  if (!isNotNullType (object.title      , 'string' )) throw new InvalidValueError('object.title'      , object.title      );
  if (!isNotNullType (object.description, 'string' )) throw new InvalidValueError('object.description', object.description);

  return {
    _newRecord: isUndefined(object._newRecord) ? isNull(object.id) : object._newRecord,
    id: object.id || uniqueId(['new_record']),
    title: object.title,
    description: object.description,
  };
}

export function makeEntity(values: Partial<Todo>): Todo {
  return fromObject({
    id: values.id || null,
    title: values.title || '',
    description: values.description || '',
  });
}
