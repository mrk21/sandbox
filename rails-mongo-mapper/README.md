# Rails mongo mapper

## Dependencies

### Middlewares/Tools

- Ruby: 3.x
- Rails: 7.x
- MySQL: 8.x
- MinIO
- Docker: >= 25.0
- Docker Compose
- direnv
- MongoDB

### Libs

- Gems
  - mongomapper
  - bson_ext

## Setup

```sh
# direnv
cp .envrc.sample .envrc
vi .envrc
direnv allow .

# application
docker compose build
docker compose run --rm app bundle
docker compose run --rm app rails db:setup
```

## References

- [Ruby MongoDB Driver — Ruby MongoDB Driver](https://www.mongodb.com/docs/ruby-driver/current/)
- [mongodb/mongo-ruby-driver: The Official MongoDB Ruby Driver](https://github.com/mongodb/mongo-ruby-driver/tree/master)
- [A Mongo ORM for Ruby // MongoMapper](https://mongomapper.com/)
- [mongomapper/mongomapper: A Ruby Object Mapper for Mongo](https://github.com/mongomapper/mongomapper/)
- [mongo - Official Image | Docker Hub](https://hub.docker.com/_/mongo)
- [mongo-express - Official Image | Docker Hub](https://hub.docker.com/_/mongo-express)
- [Ruby で YAML のエイリアスが使えなくなった？ #Ruby - Qiita](https://qiita.com/scivola/items/da2e4687726fb20953c0)
- [HEALTHCHECK - Dockerfile reference | Docker Docs](https://docs.docker.com/reference/dockerfile/#healthcheck)
