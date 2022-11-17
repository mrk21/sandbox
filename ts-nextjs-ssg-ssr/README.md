# TypeScript + Next.js (SSG/SSR)

**Tech Stacks:**

- Middlewares
    - Next.js
    - TypeScrtipt
    - Express
    - NodeJS

## Dependencies

- TypeScript: 4.9.x
- NodeJS: 19.0.0
- Next.js: 13.0.x
- React: 18.2.x
- Express: 4.18.x
- ESLint
- prettier
- nodenv

## Setup

```sh
nodenv install
yarn install
(cd src-api && yarn install)
yarn dev
(cd src-api && yarn api)
open http://localhost:3000
```

### This project creation steps

```sh
npx create-next-app@latest --typescript --eslint ts-nextjs-ssg-ssr
cd ts-nextjs-ssg-ssr
yarn add -D prettier eslint-config-prettier
```

### Memo

- [Next.jsによるSSG最低限 - Qiita](https://qiita.com/zaburo/items/ad931e266fff35e1d756)
- [[Next] getStaticPropsの型の付け方、型定義について](https://zenn.dev/eitches/articles/2021-0424-getstaticprops-type)
- [ts-nodeでESModulesのファイルを実行する](https://zenn.dev/tak_iwamoto/articles/862527e69f544e)
- [node index.ts したら `SyntaxError: Cannot use import statement outside a module` と怒られてハマった話 | コーヒー飲みながら仕事したい](https://coffee-nominagara.com/node-index-ts-syntaxerror-cannot-use-import-statement-outside-a-module)
