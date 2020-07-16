# Go goproxy

## Dependencies

- Go: 1.14.x
- goproxy
- Docker: >= 18.06
- docker-compose: >= 1.25.0
- direnv

## Setup

```sh
# 1. Install `docker`, `docker-compose`, `direnv`
#------------------------------------------------------------------------------

# 2. Setup
#------------------------------------------------------------------------------
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .
docker-compose build
docker-compose up
```

## Usage

```sh
# Allow access
docker-compose exec client curl --proxy http://proxy:8080 https://www.google.co.jp

# Allow access
docker-compose exec client curl --proxy http://proxy:8080 http://abehiroshi.la.coocan.jp

# Deny access
docker-compose exec client curl --proxy http://proxy:8080 http://nginx
```

```sh
# Deny access
curl --proxy http://localhost:${DOCKER_HOST_PROXY_PORT} https://www.google.co.jp

# Deny access
curl --proxy http://localhost:${DOCKER_HOST_PROXY_PORT} http://abehiroshi.la.coocan.jp

# Deny access
curl --proxy http://localhost:${DOCKER_HOST_PROXY_PORT} http://nginx
```

## Refer to

- [elazarl/goproxy: An HTTP proxy library for Go](https://github.com/elazarl/goproxy)
- [【Go】net/httpパッケージを読んでhttp.HandleFuncが実行される仕組み - Qiita](https://qiita.com/shoichiimamura/items/1d1c64d05f7e72e31a98)
