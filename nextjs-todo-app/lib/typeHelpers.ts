export type PropertyHolder<T> = {
  readonly [P in keyof T]?: unknown;
};

// for mapping from strings to types
// @see [Generic type guard in Typescript - DEV Community 👩‍💻👨‍💻](https://dev.to/krumpet/generic-type-guard-in-typescript-258l)
// @see [typeof - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/typeof#Description)
type TypeMap = {
  string: string;
  number: number;
  boolean: boolean;
  object: object;
  symbol: symbol;
  function: (...args: any[]) => any;
};

// constructor | 'string' | 'number' | 'boolean' | 'object' | 'symbol' | 'undefined' | 'function'
type PrimitiveOrConstructor = { new (...args: any[]): any } | keyof TypeMap;

// infer the guarded type from a specific case of PrimitiveOrConstructor
type GuardedType<T extends PrimitiveOrConstructor> =
  T extends { new(...args: any[]): infer U; } ?
    U :
    T extends keyof TypeMap ?
      TypeMap[T] :
      never;

function isType(value: unknown, type: any): boolean {
  if (typeof type === 'string') {
    return typeof value === type;
  }
  else {
    return value instanceof type;
  }
}

export function isNotNullType<T extends PrimitiveOrConstructor>(value: unknown, type: T): value is GuardedType<T> {
  if (isUndefined(value)) return false;
  if (isNull(value)) return false;
  return isType(value, type);
}

export function isNullableType<T extends PrimitiveOrConstructor>(value: unknown, type: T): value is GuardedType<T> | null {
  if (isUndefined(value)) return false;
  if (isNull(value)) return true;
  return isType(value, type);
}

export function isOptionalType<T extends PrimitiveOrConstructor>(value: unknown, type: T): value is GuardedType<T> | undefined {
  if (isUndefined(value)) return true;
  if (isNull(value)) return false;
  return isType(value, type);
}

export function isUndefined(value: unknown): value is undefined {
  return typeof value === 'undefined';
}

export function isNull(value: unknown): value is null {
  return value === null;
}

export function isNotNull<T>(value: T | null): value is T {
  return value !== null;
}
