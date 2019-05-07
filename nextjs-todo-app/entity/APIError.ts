import InvalidValueError from '~/lib/InvalidValueError';
import { PropertyHolder, isNotNullType } from '~/lib/typeHelpers';
import * as objectEntity from '~/entity/ObjectEntity';

export type APIError = {
  messages: string[];
};

export function fromObject(value: unknown): APIError {
  const object: PropertyHolder<APIError> = objectEntity.fromObject(value);

  if (!isNotNullType(object.messages, Array)) throw new InvalidValueError('object.messages' , object.messages);
  const messages = object.messages.map((message, i) => {
    if (!isNotNullType(message, 'string')) throw new InvalidValueError(`object.messages[${i}]`, message);
    return message;
  });

  return { messages };
}
