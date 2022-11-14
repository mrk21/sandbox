# Go sql-driver-mysql Date

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
- [gorp(go-mysql-driver)で独自に定義した型をカラムに割り当てる - Qiita](https://qiita.com/itoudium/items/e599daa93ff24a15f5f6)
- https://github.com/go-sql-driver/mysql/blob/fa1e4ed592daa59bcd70003263b5fc72e3de0137/utils.go#L139
- [github.com/go-sql-driver/mysql で date型のカラムをtime.Time型で扱うと日付がズレるのを回避する - mrk21::blog {}](https://mrk21.hatenablog.com/entry/2022/11/14/215840?_ga=2.156120059.1956378829.1668328205-787324126.1591002248)
