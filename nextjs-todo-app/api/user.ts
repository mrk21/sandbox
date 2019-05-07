import * as user from '~/entity/User';
import * as list from '~/entity/List';
import * as apiResponse from '~/entity/APIResponse';

const userList = list.specialize(user);
const userListAPIResponse = apiResponse.specialize({ data: userList });
const userAPIResponse = apiResponse.specialize({ data: user });

/**
 * List
 */
type GetListRawResponse = undefined | null | {
  users?: {
    data?: unknown
    error?: unknown
  };
};
export async function getList() {
  const response = await new Promise<GetListRawResponse>((resolve) => {
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
 * Detail
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
