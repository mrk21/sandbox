# S3 Cognito Direct Upload

**Features:**

- Authenticate by Amazon Cognito
- Generate AWS temporary credentials by Amazon Cognito
- Direct upload to Amazon S3

**Tech Stacks:**

- Services
    - Amazon Cognito
    - Amazon S3
- Middlewares
    - Next.js
    - TypeScrtipt
- Libraries
    - amazon-cognito-identity-js
    - aws-sdk v3

## Dependencies

- TypeScript: 4.8.x
- NodeJS: 19.0.0
- Next.js: 13.0.0
- React: 18.2.0
- amazon-cognito-identity-js: 5.2.x
- @aws-sdk: 3.x
    - @aws-sdk/client-s3
    - @aws-sdk/credential-providers
    - @aws-sdk/s3-request-presigner
- ESLint
- prettier
- nodenv

## Setup

### AWS

1. Create Cognito UserPool
    - Copy the UserPoolID
2. Create Application Client for the Cognito UserPool
    - Copy the ClientID
3. Create Cognito ID Pool
    - Set Cognito auth provider
        - Specify the UserPoolID and ClientID
    - Enable to access by UnAuth ID
    - Enable creating Auth/UnAuth IAM roles
    - Copy the IDPoolID
4. Create S3 Bucket
    - Set to private bucket
    - Set CORS policy
    - Copy the bucket name
5. Set the Auth/UnAuth IAM role policies

**S3 Bucket CORS policy:**

```json
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "HEAD",
            "POST",
            "PUT"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": [
            "Access-Control-Allow-Origin"
        ]
    }
]
```

**AuthUser IAM role policy:**

*Replace `<your-bucket-name>` to your s3 bucket name*

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListPublicObjects",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::<your-bucket-name>"
      ],
      "Condition": {
        "StringLike": {
          "s3:prefix": [
            "public/*"
          ]
        }
      }
    },
    {
      "Sid": "GetPublicObjects",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::<your-bucket-name>/public/*"
      ]
    },
    {
      "Sid": "ListYourObjects",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": [
        "arn:aws:s3:::<your-bucket-name>"
      ],
      "Condition": {
        "StringLike": {
          "s3:prefix": [
            "cognito/test/${cognito-identity.amazonaws.com:sub}/*"
          ]
        }
      }
    },
    {
      "Sid": "ReadWriteDeleteYourObjects",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::<your-bucket-name>/cognito/test/${cognito-identity.amazonaws.com:sub}/*"
      ]
    }
  ]
}
```

**UnAuthUser IAM role policy:**

*Replace `<your-bucket-name>` to your s3 bucket name*

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListPublicObjects",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::<your-bucket-name>"
      ],
      "Condition": {
        "StringLike": {
          "s3:prefix": [
            "public/*"
          ]
        }
      }
    },
    {
      "Sid": "GetPublicObjects",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::<your-bucket-name>/public/*"
      ]
    }
  ]
}
```

### Project

```sh
nodenv install
cp .env.sample .env
vi .env # Set your secret
yarn install
yarn dev
open http://localhost:3000
```

## Memo

- AWS SDK v3
    - [AWS SDK for JavaScriptは何ですか。 - AWS SDK for JavaScript](https://docs.aws.amazon.com/ja_jp/sdk-for-javascript/v3/developer-guide/welcome.html)
    - [AWS SDK for JavaScript v3](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/index.html)
    - [@aws-sdk/credential-providers | AWS SDK for JavaScript v3](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/modules/_aws_sdk_credential_providers.html)
    - [AWS SDK for JavaScript (v3) モジュールでのエラー処理 | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/service-error-handling-modular-aws-sdk-js/)
    - [Amazon Cognito アイデンティティを使用してユーザー認証をする - AWS SDK for JavaScript](https://docs.aws.amazon.com/ja_jp/sdk-for-javascript/v3/developer-guide/loading-browser-credentials-cognito.html)
    - [ブラウザから Amazon S3 へ写真をアップロードします - AWS SDK for JavaScript](https://docs.aws.amazon.com/ja_jp/sdk-for-javascript/v3/developer-guide/s3-example-photo-album.html#s3-example-photo-album-adding-photos)
    - [AWS SDK を使用して Amazon S3 の署名付き URL を作成する - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/example_s3_Scenario_PresignedUrl_section.html)
- Amazon Cognito
    - [Amazon Cognito とは - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/what-is-amazon-cognito.html)
    - [サインイン後に ID プールを使用して AWS サービスへアクセスする - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/amazon-cognito-integrating-user-pools-with-identity-pools.html)
    - [IAM ロール - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/iam-roles.html)
    - [Amazon S3: Amazon Cognito ユーザーにバケット内のオブジェクトへのアクセスを許可する - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_examples_s3_cognito-bucket.html)
    - [ID プール (フェデレーティッド ID) の使用 - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/identity-pools.html)
- React
    - [Reactの標準機能（useContext/useReducer）でステート管理[TypeScript版] | webOpixel](https://www.webopixel.net/javascript/1647.html)
- Next.js
    - [Basic Features: Environment Variables | Next.js](https://nextjs.org/docs/basic-features/environment-variables)
    - [next.config.js: Runtime Configuration | Next.js](https://nextjs.org/docs/api-reference/next.config.js/runtime-configuration)
- ESLint
  - [import-js/eslint-import-resolver-typescript: This plugin adds `TypeScript` support to `eslint-plugin-import`](https://github.com/import-js/eslint-import-resolver-typescript)
  - [Typescript/ESLint error: Unable to resolve path to module 'aws-lambda' import/no-unresolved - Stack Overflow](https://stackoverflow.com/questions/65369472/typescript-eslint-error-unable-to-resolve-path-to-module-aws-lambda-import-no)
- Others
    - [AWS Cognito SDKをNext.js(TypeScript)に組み込んで使ってみる](https://zenn.dev/ttani/articles/aws-cognito-sdk)
    - [[Cognito] 認証されていないIDに対してのアクセスを無効にする](https://zenn.dev/kzen/articles/392bf636fdddb5)
    - [AWS SDK for JavaScriptでCognito User Poolsを使ったログイン画面を作ってみた | DevelopersIO](https://dev.classmethod.jp/articles/login-form-by-using-aws-sdk-for-javascript/)
    - [S3の特定のフォルダのみを許可するIAMポリシー - Qiita](https://qiita.com/suzuki-navi/items/c4a89d0cbd1f0e075fce)
    - [【Amazon Cognito】JavaScriptでログイン処理を実装する方法 - ITを分かりやすく解説](https://medium-company.com/amazon-cognito-javascript-%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3/)
    - [[素朴な手順]CognitoでIdentityID別にS3バケットへのアクセス許可をつけてみます | DevelopersIO](https://dev.classmethod.jp/articles/cognito-trigger-allow-access-per-identity-id/)
    - [【 AWS 】Amazon Cognitoで認証を行って、S3にファイルをアップロードする仕組みを実装してみた(1) - Qiita](https://qiita.com/Futo_Horio/items/97586a3c16d939a8ab5f)
    - [AWS Cognitoを使ったサインアップとログイン機能のまとめ](https://zenn.dev/tttch/articles/2d9b921e2c84b7f87aae)
    - [CognitoユーザーのIDトークンを取得するスクリプトを書いてみた（AWS SDK for JavaScript v3） | DevelopersIO](https://dev.classmethod.jp/articles/get-the-id-token-of-a-cognito-user-aws-sdk-for-javascript-v3/)
    - [AWS Cognito SDKをNext.js(TypeScript)に組み込んで使ってみる](https://zenn.dev/ttani/articles/aws-cognito-sdk)
    - [AWS再入門ブログリレー Amazon Cognito編 | DevelopersIO](https://dev.classmethod.jp/articles/re-introduction-2020-amazon-cognito/)

### This project creation steps

```sh
npx create-next-app@latest --typescript --eslint ts-s3-cognito-direct-upload
cd ts-s3-cognito-direct-upload

yarn add -D prettier eslint-config-prettier

yarn add amazon-cognito-identity-js
yarn add @aws-sdk/client-s3
yarn add @aws-sdk/credential-providers
yarn add @aws-sdk/s3-request-presigner
```

- [next.js/packages/create-next-app at canary · vercel/next.js](https://github.com/vercel/next.js/tree/canary/packages/create-next-app)
- [Getting Started | Next.js](https://nextjs.org/docs/getting-started)
- [【2022年】Next.js + TypeScript + ESLint + Prettier の構成でサクッと環境構築する](https://zenn.dev/hungry_goat/articles/b7ea123eeaaa44)
