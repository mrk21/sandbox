# ts react msw

## Dependencies

- Node.js
- TypeScript
- Vite
- SWC
- React
- Jest
- MSW

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
✔ Project name: … ts-react-msw
✔ Select a framework: › React
✔ Select a variant: › TypeScript + SWC

$ cd ts-react-msw
$ npm install msw@latest --save-dev
$ npm install
$ npx msw init ./public

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
$ npm install --save-dev undici@^5.0.0
$ npx ts-jest config:init

$ npm install --save-dev @testing-library/react @testing-library/user-event
```

## References

- [Mock Service Worker - API mocking library for browser and Node.js](https://mswjs.io/)
- [listen() - Mock Service Worker](https://mswjs.io/docs/api/setup-server/listen#onunhandledrequest)
- [React Testing Library | Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [yasamoka/react-ts-vite-swc-jest-template](https://github.com/yasamoka/react-ts-vite-swc-jest-template/tree/main)
- [1.x → 2.x - Mock Service Worker](https://mswjs.io/docs/migrations/1.x-to-2.x#requestresponsetextencoder-is-not-defined-jest)

---

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh
