# rails semantic logger

## Dependencies

- Ruby: 3.x
- Rails: 7.x
- MySQL: 8.x
- Docker: >= 25.0
- Docker Compose
- direnv

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

- [reidmorrison/semantic_logger: Semantic Logger is a feature rich logging framework, and replacement for existing Ruby & Rails loggers.](https://github.com/reidmorrison/semantic_logger)
- [reidmorrison/rails_semantic_logger: Rails Semantic Logger replaces the Rails default logger with Semantic Logger](https://github.com/reidmorrison/rails_semantic_logger)
- [Semantic Logger for Ruby or Rails. Supports Graylog, Bugsnag, MongoDB, Splunk, Syslog, NewRelic.](https://logger.rocketjob.io/)
- [Railsアプリでrakeタスクのログを見やすくする - アジャイルSEの憂鬱](https://sinsoku.hatenablog.com/entry/2019/02/15/192151)
