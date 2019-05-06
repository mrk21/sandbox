import { Todo, fromObject as todoFromObject } from '~/entity/Todo';
import { isNotNullType } from '~/lib/typeHelpers';
import apiResponse, { APIResponse } from '~/entity/APIResponse';
import InvalidValueError from '~/lib/InvalidValueError';

const todoAPIResponse = apiResponse({ fromObjectForData: todoFromObject });
const todoListAPIResponse = apiResponse({
  fromObjectForData(data: unknown) {
    if (!isNotNullType(data, Array)) throw new InvalidValueError('data', data);
    return data.map(todoFromObject);
  }
});

/**
 * List
 */
type GetListRawResponse = undefined | null | {
  todos?: {
    data?: unknown
    error?: unknown
  };
};
export async function getList(): Promise<APIResponse<Array<Todo>>> {
  const response = await new Promise<GetListRawResponse>((resolve) => {
    setTimeout(() => {
      resolve({
        todos: {
          data: ['1', '2', '4', '8'].map((id) => ({
            id,
            title: `title ${id}`,
            description: `description ${id}`,
          })),
        },
      });
    }, 1000);
  });
  const todos = (response || {}).todos || {};
  const data = todos.data || null;
  const error = todos.error || null;
  return todoListAPIResponse.fromObject({ data, error });
}

/**
 * Detail
 */
type GetInput = {
  id: string;
};
type GetRawResponse = undefined | null | {
  todo?: {
    data?: unknown
    error?: unknown
  };
};
export async function get({ id }: GetInput): Promise<APIResponse<Todo>> {
  const response = await new Promise<GetRawResponse>((resolve) => {
    setTimeout(() => {
      if (parseInt(id) <= 0) {
        resolve({
          todo: {
            error: {
              messages: [
                "Not found"
              ],
            },
          },
        });
      }
      else {
        resolve({
          todo: {
            data: {
              id,
              title: `title ${id}`,
              description: `description ${id}`,
            },
          },
        });
      }
    }, 1000);
  });
  const todo = (response || {}).todo || {};
  const data = todo.data || null;
  const error = todo.error || null;
  return todoAPIResponse.fromObject({ data, error });
}

export default { getList, get };
