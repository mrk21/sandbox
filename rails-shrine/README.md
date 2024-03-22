# Rails shrine

## Dependencies

### Middlewares/Tools

- Ruby: 3.x
- Rails: 7.x
- MySQL: 8.x
- MinIO
- Docker
- Docker Compose
- direnv

### Libs

- gems:
  - shrine
  - image_processing
  - aws-sdk-s3
- apt:
  - libvips-dev

## Setup

```sh
# direnv
cp .envrc.sample .envrc
vi .envrc
direnv allow .

# minio
docker compose run --rm mc mb minio/file
docker compose run --rm mc anonymous set public minio/file

# application
docker compose run --rm app bundle
docker compose run --rm app rails db:setup
```

## References

- [Home | Shrine](https://shrinerb.com/)
- [shrinerb/shrine: File Attachment toolkit for Ruby applications](https://github.com/shrinerb/shrine)
