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

## Setup

```sh
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .
docker-compose build
docker-compose run app bundle install
docker-compose run app rails db:setup
docker-compose run app bundle exec rails c
docker-compose up
open http://localhost:${DOCKER_HOST_APP_PORT}/
```

## Deploy

Deploy to AWS ECS.

```sh
#------------------------------------------------------------------------------
# 1. Install `awscli` `ecs-cli` `jq`
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# 2. Set environment variables listed bellow:
#------------------------------------------------------------------------------
vi .envrc.local
# export AWS_ACCOUNT_ID=xxxx
# export AWS_ACCESS_KEY_ID=xxxx
# export AWS_SECRET_ACCESS_KEY=xxxx
# export AWS_DEFAULT_REGION=xxxx

#------------------------------------------------------------------------------
# 3. Reload direnv config
#------------------------------------------------------------------------------
direnv allow .

#------------------------------------------------------------------------------
# 4. Execute deploy script
#------------------------------------------------------------------------------
RAILS_ENV=production ./deploy/deploy.sh
```
