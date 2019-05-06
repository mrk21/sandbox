import InvalidValueError from '~/lib/InvalidValueError';
import { PropertyHolder, isNotNullType } from '~/lib/typeHelpers';

export type APIError = {
  messages: string[];
};

export function fromObject(value: unknown): APIError {
  if (!isNotNullType(value, 'object')) throw new InvalidValueError('object', value);

  const object: PropertyHolder<APIError> = value;

  if (!isNotNullType(object.messages, Array)) throw new InvalidValueError('object.messages' , object.messages);
  const messages = object.messages.map((message, i) => {
    if (!isNotNullType(message, 'string')) throw new InvalidValueError(`object.messages[${i}]`, message);
    return message;
  });

  return { messages };
}
