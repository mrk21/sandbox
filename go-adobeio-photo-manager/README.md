# go-adobeio-photo-manager

## mkcert

[mkcert](https://github.com/FiloSottile/mkcert)

### Install local CA

```sh
mkcert -install
```

### Create certificate

```
cd docker/nginx
mkcert localhost 127.0.0.1 ::1
```

## docker

### install devcontainer-cli

- https://code.visualstudio.com/docs/remote/devcontainer-cli

## use vscode remote

```sh
docker-compose up
devcontainer open
```

## Adobe Lightroom API

[API Docs](https://www.adobe.io/apis/creativecloud/lightroom/apidocs.html#!docs/api/LightroomPartnerAPIsSpec.json)
