# rails migration reporting

## Dependencies

### Middleware/tools

#### Required

- Ruby: 2.7.1
- Rails: 6.0.3
- MySQL: 5.7.x
- Node.js
- yarn

##### for gem

- MySQL library: 5.7.x

#### Optional

##### Development

- Docker: >= 18.06
- docker-compose: >= 1.25.0
- direnv

## Setup

```sh
#------------------------------------------------------------------------------
# 1. Install `docker`, `docker-compose`, `direnv`
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# 2. Setup app
#------------------------------------------------------------------------------
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .
docker-compose build
docker-compose run app bundle install
docker-compose run app yarn install
docker-compose run app rails db:create
docker-compose up
```

## Usage

```sh
# Report migration on `git push`
docker-compose exec app rails r script/migration_diff # notify

# Report migration on `rails db:migrate`
docker-compose run app rails db:migrate # migration and notify
tree tmp/migration_reporter # report result
```
