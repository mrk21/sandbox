# Rails Cloud pub/sub

## Dependencies

- Ruby: 3.3.0
- Rails: 7.x
- MySQL: 8.x
- Docker
- Docker Compose
- direnv
- Google Cloud CLI

## Setup

```sh
# direnv
cp .envrc.sample .envrc
vi .envrc # edit your settings
direnv allow .

# install Google Cloud CLI
# @see [gcloud CLI をインストールする  |  Google Cloud CLI Documentation](https://cloud.google.com/sdk/docs/install?hl=ja)

# init cloud pub/sub
gcloud init # select or create your project
gcloud services enable pubsub.googleapis.com
gcloud auth application-default login
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member="user:${EMAIL_ADDRESS}" --role=${ROLE}

# create service account
gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME} \
  --description="${SERVICE_ACCOUNT_NAME}" \
  --display-name="${SERVICE_ACCOUNT_NAME}"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role=${ROLE}
gcloud iam service-accounts keys create ./tmp/service-account.json \
    --iam-account=${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

# create pub/sub
gcloud pubsub topics create my-topic
gcloud pubsub subscriptions create my-sub --topic my-topic

# application
docker compose run --rm app bundle
docker compose run --rm app rails db:setup

# run pubsub test
docker compose run --rm app rails pubsub:test

# boot app
docker compose up
open http://localhost:3000
```

## Usage

```sh
# boot app
docker compose up

# run pubsub test
docker compose run --rm app rails pubsub:test

# open devcontainer
devcontainer open .
```

## References

- [クイックスタート: クライアント ライブラリを使用して Pub/Sub でメッセージをパブリッシュおよび受信する  |  Pub/Sub Documentation  |  Google Cloud](https://cloud.google.com/pubsub/docs/publish-receive-messages-client-library?hl=ja)
- [サービス アカウント キーの作成と管理  |  IAM のドキュメント  |  Google Cloud](https://cloud.google.com/iam/docs/creating-managing-service-account-keys?hl=ja#iam-service-account-keys-create-gcloud)
- [サービス アカウントを作成する  |  IAM のドキュメント  |  Google Cloud](https://cloud.google.com/iam/docs/service-accounts-create?hl=ja#gcloud)
- [google-cloud-ruby/google-cloud-pubsub at main · googleapis/google-cloud-ruby](https://github.com/googleapis/google-cloud-ruby/tree/main/google-cloud-pubsub)
