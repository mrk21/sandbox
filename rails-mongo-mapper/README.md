# Rails mongo mapper

## Dependencies

### Middlewares/Tools

- Ruby: 3.3.0
- Rails: 7.x
- MySQL: 8.x
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

## Development

```sh
# boot application
docker compose up

# boot DevContainer for VSCode
devcontainer open .

# insert many records to MongoDB
docker compose run --rm app rails mongo:insert

# open application
open http://localhost:3000/

# open mongo-express
open http://root:example@localhost:8081/
```

## References

- [What is MongoDB? - MongoDB Manual v7.0](https://www.mongodb.com/docs/manual/)
- [Ruby MongoDB Driver — Ruby MongoDB Driver](https://www.mongodb.com/docs/ruby-driver/current/)
- [mongodb/mongo-ruby-driver: The Official MongoDB Ruby Driver](https://github.com/mongodb/mongo-ruby-driver/tree/master)
- [A Mongo ORM for Ruby // MongoMapper](https://mongomapper.com/)
- [mongomapper/mongomapper: A Ruby Object Mapper for Mongo](https://github.com/mongomapper/mongomapper/)
- [mongo - Official Image | Docker Hub](https://hub.docker.com/_/mongo)
- [mongo-express - Official Image | Docker Hub](https://hub.docker.com/_/mongo-express)
- [Ruby で YAML のエイリアスが使えなくなった？ #Ruby - Qiita](https://qiita.com/scivola/items/da2e4687726fb20953c0)
- [HEALTHCHECK - Dockerfile reference | Docker Docs](https://docs.docker.com/reference/dockerfile/#healthcheck)
- [Treasure Data から大量のデータを MongoDB にインポートする話 - スタディサプリ Product Team Blog](https://blog.studysapuri.jp/entry/2016/10/14/190121)

## Memo

**find_by_xxx:**

- https://github.com/mongomapper/mongomapper/blob/master/lib/mongo_mapper/plugins/dynamic_querying.rb
- https://github.com/mongomapper/mongomapper/blob/master/lib/mongo_mapper/plugins/dynamic_querying/dynamic_finder.rb
