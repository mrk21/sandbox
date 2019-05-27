import * as user from '~/entity/User';
import * as list from '~/entity/List';
import * as apiResponse from '~/entity/APIResponse';
import { uniq } from 'lodash';

const userList = list.specialize(user);
const userListAPIResponse = apiResponse.specialize({ data: userList });
const userAPIResponse = apiResponse.specialize({ data: user });

/**
 * GET /users
 */
type GetListRawResponse = undefined | null | {
  users?: {
    data?: unknown
    error?: unknown
  };
};
export async function getList() {
  const response = await new Promise<GetListRawResponse>((resolve) => {
    console.log(`GET /users`);
    setTimeout(() => {
      resolve({
        users: {
          data: ['1', '2', '4', '8'].map((id) => ({
            id,
            name: `user ${id}`,
          })),
        },
      });
    }, Math.random() * 900 + 100);
  });
  const users = (response || {}).users || {};
  const data = users.data || null;
  const error = users.error || null;
  return userListAPIResponse.fromObject({ data, error });
}

/**
 * GET /users/batch/:ids
 */
type BatchGetRawResponse = undefined | null | {
  data: {
    [ key: string ]: {
      user?: {
        data?: unknown
        error?: unknown
      };
    }
  };
};
export async function batchGet(paramsList: Array<{ id: string; }>) {
  const ids = uniq(paramsList.map(({ id }) => id));
  const response = await new Promise<BatchGetRawResponse>((resolve) => {
    console.log(`GET /users/batch/${ids.join(',')}`);
    setTimeout(() => {
      resolve({
        data: ids.reduce<any>((result, id) => {
          result[id] = {
            user: {
              data: {
                id,
                name: `user ${id}`,
              },
            },
          };
          return result;
        }, {})
      });
    }, Math.random() * 900 + 100);
  });
  const _data: any = response ? response.data : {};
  let result: { [key: string]: apiResponse.APIResponse<user.User>; } = {};

  Object.entries<any>(_data).forEach((entry: any) => {
    result[entry[0]] = userAPIResponse.fromObject({ data: entry[1].user.data, error: null });
  });
  return result;
}

/**
 * GET /users/:id
 */
type GetInput = {
  id: string;
};
type GetRawResponse = undefined | null | {
  user?: {
    data?: unknown
    error?: unknown
  };
};
export async function get({ id }: GetInput) {
  const response = await new Promise<GetRawResponse>((resolve) => {
    console.log(`GET /users/${id}`);
    setTimeout(() => {
      if (parseInt(id) <= 0) {
        resolve({
          user: {
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
          user: {
            data: {
              id,
              name: `user ${id}`,
            },
          },
        });
      }
    }, Math.random() * 900 + 100);
  });
  const user = (response || {}).user || {};
  const data = user.data || null;
  const error = user.error || null;
  return userAPIResponse.fromObject({ data, error });
}
