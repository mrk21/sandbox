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

- Docker: >= 18.06
- docker-compose: >= 1.25.0
- direnv

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
