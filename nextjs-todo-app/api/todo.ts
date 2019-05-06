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
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (id === '-1') {
        reject({
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
  })
  .then((response: GetRawResponse) => {
    const data = ((response || {}).todo || {}).data;
    const error = null;
    return todoAPIResponse.fromObject({ data, error });
  })
  .catch((e: Error | GetRawResponse) => {
    if (e instanceof Error) {
      console.error(e);
      return todoAPIResponse.fromObject({ data: null, error: null });
    }
    else {
      const data = null;
      const error = ((e || {}).todo || {}).error;
      return todoAPIResponse.fromObject({ data, error });
    }
  });
}

export default { get };
