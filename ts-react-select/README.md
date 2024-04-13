# ts react select

## Dependencies

- Node.js
- TypeScript
- Vite
- SWC
- React
- Jest

## Libs

- npm packages:
  - react-select
  - react-select-event

## Setup

```sh
npm install
```

## Development

```sh
# run
npm run dev
open http://localhost:5173/

# test
npm run test
```

## Memo

```sh
$ npm create vite@latest
✔ Project name: … ts-react-select
✔ Select a framework: › React
✔ Select a variant: › TypeScript + SWC

$ cd ts-react-select
$ npm install
$ npm install --save react-select
$ npm install --save-dev react-select-event

$ npm install --save-dev \
  jest \
  @swc/jest \
  @types/jest \
  jest-environment-jsdom \
  jest-svg-transformer \
  resize-observer-polyfill \
  @testing-library/jest-dom \
  @testing-library/react \
  identity-obj-proxy \
  ts-node

$ npm install --save-dev @testing-library/react @testing-library/user-event

$ npx ts-jest config:init
# Edit .swcrc, jest.config.js, jest.setup.js
```

## References

- [React Testing Library | Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [yasamoka/react-ts-vite-swc-jest-template](https://github.com/yasamoka/react-ts-vite-swc-jest-template/tree/main)
- [React Select](https://react-select.com/home)
- [JedWatson/react-select: The Select Component for React.js](https://github.com/jedwatson/react-select)
- [react-select-event | Testing Library](https://testing-library.com/docs/ecosystem-react-select-event)
- [romgain/react-select-event: 🦗 Simulate react-select events for react-testing-library](https://github.com/romgain/react-select-event)
