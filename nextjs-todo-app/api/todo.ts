import { Todo, fromObject } from '~/entity/Todo';
import apiResponse, { APIResponse } from '~/entity/APIResponse';

const todoAPIResponse = apiResponse({ fromObjectForData: fromObject });

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
      if (id === '-1') {
        resolve({
          todo: {
            error: {
              messages: [
                `invalid id: ${id}`
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

export default { get };
