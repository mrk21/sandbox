import isServer from '~/lib/isServer';
import { uniqueId as lodashUniqueId } from 'lodash';

export default function uniqueId(prefix: string[] = []) {
  const lodashPrefix = isServer ? [...prefix, 'server'] : prefix;
  return lodashUniqueId(lodashPrefix.join('/') + '/');
}
