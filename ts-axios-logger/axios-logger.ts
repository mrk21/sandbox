import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from 'axios';

/**
 * If you want to output pretty, you change the following value to true.
 */
const pretty = false;

/**
 * Inject logger to specified axios instance
 * @notice IT DOES NOT IMPLEMENT MASKING CREDENTIALS, SO YOU SHOULD ADD MASKING, OR YOU SHOULD DISABLE THAT OTHER THAN LOCAL ENVIRONMENT.
 */
export function injectAxiosLogger(instance: AxiosInstance): AxiosInstance {
  if (process.env.NODE_ENV === 'production') return instance;
  const bar = [...times(120)].map((_) => '-').join('');

  instance.interceptors.request.use((request) => {
    const req = dumpAxiosRequestConfig(request);
    console.log(`${bar}\nStarting HTTP Request\n${bar}\n${req}\n${bar}`);
    return request;
  });

  instance.interceptors.response.use((response) => {
    const req = dumpAxiosRequestConfig(response.config);
    const res = dumpAxiosResponse(response);
    console.log(
      `${bar}\nHTTP Request Completed\n${bar}\n${req}\n${bar}\n${res}\n${bar}`
    );
    return response;
  });

  return instance;
}

/**
 * Dump HTTP Request
 * @see AxiosRequestConfig https://github.com/axios/axios?tab=readme-ov-file#request-config
 * @see https://sabljakovich.medium.com/axios-interceptors-log-request-and-response-72b01333a760
 */
export function dumpAxiosRequestConfig(req: AxiosRequestConfig) {
  const method = req.method?.toLocaleLowerCase() || '';
  const baseURL = req.baseURL || '';
  const path = req.url || '';
  const params =
    req.params instanceof URLSearchParams
      ? req.params
      : new URLSearchParams(req.params || {});
  let headers = req.headers || {};
  headers = {
    ...(headers.common || {}),
    ...(headers[method] || {}),
    ...headers,
  };
  for (let h of ['common', 'get', 'post', 'head', 'put', 'patch', 'delete']) {
    delete headers[h];
  }
  const data = req.data;

  const rawParams = params.toString();
  const rawHeaders = Object.entries(headers)
    .map(([k, v]) => `${k}: ${v}`)
    .join('\n');
  const rawData = dumpData(data);
  let msg = `${method.toUpperCase()} ${baseURL}${path} HTTP/1.1`;
  msg += rawParams ? `?${rawParams}` : '';
  msg += rawHeaders ? `\n${rawHeaders}` : '';
  msg += rawData ? `\n\n${rawData}` : '';
  return msg;
}

/**
 * Dump HTTP Response
 * @see AxiosResponse https://github.com/axios/axios?tab=readme-ov-file#response-schema
 */
export function dumpAxiosResponse<T>(res: AxiosResponse<T>) {
  const status = res.status;
  const statusText = res.statusText;
  const headers = res.headers || {};
  const data = res.data;

  const rawHeaders = Object.entries(headers)
    .map(([k, v]) => `${k}: ${v}`)
    .join('\n');
  const rawData = dumpData(data);

  let msg = `HTTP/1.1 ${status} ${statusText}`;
  msg += rawHeaders ? `\n${rawHeaders}` : '';
  msg += rawData ? `\n\n${rawData}` : '';
  return msg;
}

function *times(n: number) {
  for (let i = 0; i < n; i++) yield i;
}

function dumpData(data: any) {
  return data
    ? typeof data === 'object'
      ? pretty
        ? JSON.stringify(data, null, ' ')
        : JSON.stringify(data)
      : data
    : '';
}
