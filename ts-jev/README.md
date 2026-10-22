# jev test

## Dependencies

- Node.js 26.2.0 (`.tool-versions` / `.node-version`)
- TypeScript
- asdf
- direnv
- 1Password CLI

## Libs

- npm packages:
  - @typesafe-ai/sdk

## Setup

```sh
asdf install
npm install

cp .envrc.sample .envrc
# Edit .envrc: set TYPESAFE_API_KEY to a 1Password secret reference (op://<Vault>/<Name>/<Item>)
direnv allow
```

## Development

```sh
# check API key (list available models)
op run -- npm run check-key

# run
op run -- npm start

# typecheck
npm run typecheck
```

## Examples

```sh
op run -- node src/examples/moderation.ts        # 投稿モデレーション (noul + criteria, choice)
op run -- node src/examples/rag-judge.ts         # RAG 回答の評価 (score rubric)
op run -- node src/examples/batch-triage.ts      # 問い合わせの一括振り分け (並列数制限, 低確信度は人へ)
op run -- node src/examples/image-inspection.ts photo.jpg  # 編みぐるみ判定 + box (jev-preview, experimental)
```

## Memo

```sh
$ npm init -y
$ npm install --save @typesafe-ai/sdk
$ npm install --save-dev typescript @types/node
# Edit package.json ("type": "module", scripts), tsconfig.json
```

## References

- [Running TypeScript Natively | Node.js](https://nodejs.org/en/learn/typescript/run-natively)
- [Load secrets into the environment | 1Password CLI](https://developer.1password.com/docs/cli/secrets-environment-variables/)
- [direnv](https://direnv.net/)
