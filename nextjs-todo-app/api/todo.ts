import * as todo from '~/entity/Todo';
import * as list from '~/entity/List';
import * as apiResponse from '~/entity/APIResponse';
import { times, uniqueId } from 'lodash';

const todoList = list.specialize(todo);
const todoListAPIResponse = apiResponse.specialize({ data: todoList });
const todoAPIResponse = apiResponse.specialize({ data: todo });

/**
 * GET /todos
 */
type GetListRawResponse = undefined | null | {
  todos?: {
    data?: unknown
    error?: unknown
  };
};
export async function getList() {
  const response = await new Promise<GetListRawResponse>((resolve) => {
    console.log('GET /todos');
    setTimeout(() => {
      resolve({
        todos: {
          data: times(Math.round(Math.random() * 20 + 2)).map(() => {
            const id = uniqueId();
            const assignerId = (() => {
              const v = Math.round(Math.random() * 30 - 5);
              return v <= 0 ? null : v.toString();
            })();
            return {
              id,
              title: `title ${id}`,
              description: `description ${id}`,
              assignerId,
            }
          }),
        },
      });
    }, Math.random() * 900 + 100);
  });
  const todos = (response || {}).todos || {};
  const data = todos.data || null;
  const error = todos.error || null;
  return todoListAPIResponse.fromObject({ data, error });
}

/**
 * GET /todos/:id
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
export async function get({ id }: GetInput) {
  const response = await new Promise<GetRawResponse>((resolve) => {
    console.log(`GET /todos/${id}`);
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
              assignerId: id,
            },
          },
        });
      }
    }, Math.random() * 900 + 100);
  });
  const todo = (response || {}).todo || {};
  const data = todo.data || null;
  const error = todo.error || null;
  return todoAPIResponse.fromObject({ data, error });
}

/**
 * POST /todos
 */
type CreateInput = {
  title: string;
  description?: string;
  assignerId?: string | null;
};
type CreateRawResponse = undefined | null | {
  createTodo?: {
    data?: unknown
    error?: unknown
  };
};
export async function create(input: CreateInput) {
  const response = await new Promise<CreateRawResponse>((resolve) => {
    console.log('POST /todos');
    setTimeout(() => {
      resolve({
        createTodo: {
          data: {
            id: uniqueId(),
            title: input.title,
            description: input.description || '',
            assignerId: input.assignerId || null,
          },
        },
      });
    }, Math.random() * 900 + 100);
  });
  const todo = (response || {}).createTodo || {};
  const data = todo.data || null;
  const error = todo.error || null;
  return todoAPIResponse.fromObject({ data, error });
}
