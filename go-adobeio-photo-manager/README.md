# go-adobeio-photo-manager

## Setup

### mkcert

[mkcert](https://github.com/FiloSottile/mkcert)

#### Install local CA

```sh
mkcert -install
```

#### Create certificate

```
cd docker/nginx
mkcert localhost 127.0.0.1 ::1
```

### docker

```
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .
docker-compose build
docker-compose up
docker-compose exec app go run cmd/photomgr/*.go
open https://localhost:8000/
```

### Optional: install devcontainer-cli

- https://code.visualstudio.com/docs/remote/devcontainer-cli

#### Use vscode remote

```sh
docker-compose up
devcontainer open
```

## Refer to

### Adobe Lightroom API

[API Docs](https://www.adobe.io/apis/creativecloud/lightroom/apidocs.html#!docs/api/LightroomPartnerAPIsSpec.json)
