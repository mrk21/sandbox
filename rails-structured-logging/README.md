# rails structured logging

## Dependencies

### Middleware/tools

#### Required

- Ruby: 2.7.1
- Rails: 6.0.3
- MySQL: 5.7.x
- Redis: 6.0.x
- Node.js
- yarn

##### for gem

- MySQL library: 5.7.x

#### Optional

##### Development

- Docker: >= 18.06
- docker-compose: >= 1.25.0
- direnv

##### Deploy

- awscli
- ecs-cli
- jq

##### Infra

- terraform

## Setup

```sh
# 1. Install `docker`, `docker-compose`, `direnv`
#------------------------------------------------------------------------------

# 2. Setup app
#------------------------------------------------------------------------------
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .
docker-compose build
docker-compose run app bundle install
docker-compose run app rails db:setup
docker-compose up
open http://localhost:${DOCKER_HOST_APP_PORT}/
```

## Deploy

Deploy to AWS ECS.

```sh
# 1. Install `awscli` `ecs-cli` `jq`
#------------------------------------------------------------------------------

# 2. Set environment variables listed bellow:
#------------------------------------------------------------------------------
vi .envrc.local
# export AWS_ACCOUNT_ID=xxxx
# export AWS_ACCESS_KEY_ID=xxxx
# export AWS_SECRET_ACCESS_KEY=xxxx
# export AWS_DEFAULT_REGION=xxxx

# 3. Reload direnv config
#------------------------------------------------------------------------------
direnv allow .

# 4. Execute deploy script
#------------------------------------------------------------------------------
RAILS_ENV=production ./deploy/deploy.sh
```

## Setup Infra

```sh
# 1. Create key
#------------------------------------------------------------------------------
cd infra/secrents
ssh-keygen -t rsa -b 4096 -m pem -C "rails-structured-logging" -f rails-structured-logging.pem -N ""

# 2. Run terraform
#------------------------------------------------------------------------------
cd infra/terraform/enviromnents/production

cd network
terraform init .
terraform apply

cd secrets
terraform init .
terraform apply

cd security_group
terraform init .
terraform apply

cd iam
terraform init .
terraform apply

cd logging
terraform init .
terraform apply

cd datastore
terraform init .
terraform apply

cd app
terraform init .
terraform apply

cd bastion
terraform init .
terraform apply
```
