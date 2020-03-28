import { assertType } from 'typescript-is';

type User = {
  id: number;
  name: string;
};

function decode(object: any): User {
  return assertType<User>(object);
}

console.log('## When an object has valid properties');
try {
  const object = { id: 1, name: 'hoge' }
  const user = decode(object);
  console.log(user); // OK
} catch (error) {
  console.log(error);
}

console.log('');
console.log('## When an object has valid properties and unnecessary properties');
try {
  const object = { id: 1, name: 'hoge', value: 1 }
  const user = decode(object);
  console.log(user); // OK
} catch (error) {
  console.log(error);
}

console.log('');
console.log('## When an object has invalid properties');
try {
  const object = { foo: '1' }
  const user = decode(object);
  console.log(user);
} catch (error) {
  // TypeGuardError: validation failed at object: expected 'id' in object
  //     at Object.assertType (/path/to/typescript-is-npm/node_modules/typescript-is/index.js:62:15)
  //     at Object.<anonymous> (/path/to/typescript-is-npm/index.js:81:32)
  //     at Module._compile (internal/modules/cjs/loader.js:1147:30)
  //     at Object.Module._extensions..js (internal/modules/cjs/loader.js:1167:10)
  //     at Module.load (internal/modules/cjs/loader.js:996:32)
  //     at Function.Module._load (internal/modules/cjs/loader.js:896:14)
  //     at Function.executeUserEntryPoint [as runMain] (internal/modules/run_main.js:71:12)
  //     at internal/main/run_main_module.js:17:47 {
  //   name: 'TypeGuardError',
  //   path: [ 'object' ],
  //   reason: { type: 'missing-property', property: 'id' }
  // }
  console.log(error);
}
