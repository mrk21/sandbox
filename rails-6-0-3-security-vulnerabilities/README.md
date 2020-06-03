# rails 6.0.3 security vulnerabilities

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
docker-compose run app yarn install
docker-compose run app rails db:setup
docker-compose up
open http://localhost:${DOCKER_HOST_APP_PORT}/
```

## Refer to

- [Rails 5.2.4.3 and 6.0.3.1 have been released | Riding Rails](https://weblog.rubyonrails.org/2020/5/18/Rails-5-2-4-3-and-6-0-3-1-have-been-released/)
