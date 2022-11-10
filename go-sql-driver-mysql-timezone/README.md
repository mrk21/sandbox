# Go sql-driver-mysql Time zone

## Dependencies

- Go: 1.19.3
- MySQL: 8.0
- github.com/go-sql-driver/mysql: v1.6.0

## Setup

```sh
docker-compose run db mysql -uroot -e 'create database go_tz;'
```

## Run

```sh
docker-compose up
docker-compose exec app go run main.go
```

## See

- [go-sql-driver/mysql: Go MySQL Driver is a MySQL driver for Go's (golang) database/sql package](https://github.com/go-sql-driver/mysql)
- [github.com/go-sql-driver/mysql で datetime型のカラムのタイムゾーンを適切に扱う - mrk21::blog {}](https://mrk21.hatenablog.com/entry/2022/11/10/232922)
