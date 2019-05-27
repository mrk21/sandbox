import { debounce } from 'lodash';

export default function batchRequest<Params, Result>({ batchInterval, batchMax, batchAPI, paramsToId }: {
  batchInterval: number;
  batchMax: number;
  batchAPI: (paramsList: Params[]) => Promise<{ [key: string]: Result; }>;
  paramsToId: (params: Params) => string;
}) {
  const queue: { params: Params; resolve: (result: Result) => void; }[] = [];

  const request = async () => {
    const queue_ = queue.splice(0);
    if (queue_.length === 0) return;

    const paramsList = queue_.map(({ params }) => params);
    console.debug('### batch request: request:', paramsList);
    const results = await batchAPI(paramsList);

    queue_.forEach(({ params, resolve }) => {
      const result = results[paramsToId(params)];
      console.debug('### batch request: resolve:', params, result);
      resolve(result);
    });
  };

  const requestDebounced = debounce(request, batchInterval);

  return async (params: Params) => {
    requestDebounced();
  
    return new Promise<Result>((resolve) => {
      console.debug('### batch request: push:', params);
      queue.push({ params, resolve });
      if (queue.length >= batchMax) {
        requestDebounced.flush();
      }
    });
  };
}
