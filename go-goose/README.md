# Go goose

## Dependencies

* Go: 1.14.x
- Docker: >= 18.06
- docker-compose: >= 1.25.0
- direnv

## Setup

```sh
#------------------------------------------------------------------------------
# 1. Install `docker`, `docker-compose`, `direnv`
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# 2. Setup
#------------------------------------------------------------------------------
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .
docker-compose up
docker-compose exec -T db mysql < db/create_database.sql
```

## Usage

```sh
goose up
```

## Refere to

- [pressly/goose at v2.6.0](https://github.com/pressly/goose/tree/v2.6.0)
- [goose/examples/go-migrations at v2.6.0 · pressly/goose](https://github.com/pressly/goose/tree/v2.6.0/examples/go-migrations)
