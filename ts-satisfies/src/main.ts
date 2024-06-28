type User = {
  id: string;
  name: string;
};

function literal<T>(value: T): T {
  return value;
}

// type unsafe
const value1 = {
  user: {} as User,
};

// type safe
const value2 = {
  user: literal<User>({
    id: '1',
    name: 'name 2',
  }),
};

// type safe
const value3 = {
  user: {
    id: '1',
    name: 'name 3',
  } satisfies User,
};

document.querySelector<HTMLDivElement>('#app')!.innerHTML = `
  <div>
    <pre>${JSON.stringify(value1)}</pre>
    <pre>${JSON.stringify(value2)}</pre>
    <pre>${JSON.stringify(value3)}</pre>
  </div>
`
