import InvalidValueError from '~/lib/InvalidValueError';
import { PropertyHolder, isNullableType, isOptionalType, isNull, isUndefined } from '~/lib/typeHelpers';
import * as objectEntity from '~/entity/ObjectEntity';
import uniqueId from '~/lib/uniqueId';

export type APIResourceBase = {
  readonly _newRecord: boolean;
  id: string;
};

export function fromObject(value: unknown): APIResourceBase {
  const object: PropertyHolder<APIResourceBase> = objectEntity.fromObject(value);

  if (!isOptionalType(object._newRecord , 'boolean')) throw new InvalidValueError('object._newRecord' , object._newRecord );
  if (!isNullableType(object.id         , 'string' )) throw new InvalidValueError('object.id'         , object.id         );

  return {
    _newRecord: isUndefined(object._newRecord) ? isNull(object.id) : object._newRecord,
    id: object.id || uniqueId(['new_record']),
  };
}

export function makeEntity(values: Partial<APIResourceBase>): APIResourceBase {
  return fromObject({
    id: values.id || null,
  });
}
