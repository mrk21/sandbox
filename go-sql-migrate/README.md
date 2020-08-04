# Go sql-migrate

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
go get -v github.com/rubenv/sql-migrate/...
```

## Usage

```sh
sql-migrate up
```

## Refere to

- [rubenv/sql-migrate: SQL schema migration tool for Go.](https://github.com/rubenv/sql-migrate)
