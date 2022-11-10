package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	"github.com/go-sql-driver/mysql"
)

func main() {
	locale, err := time.LoadLocation("Asia/Tokyo")
	if err != nil {
		panic(err)
	}
	c := mysql.Config{
		DBName:    "go_tz",
		User:      "root",
		Passwd:    "",
		Addr:      "db:3306",
		Net:       "tcp",
		Collation: "utf8mb4_bin",
		ParseTime: true,
		Loc:       locale,
	}
	dsn := c.FormatDSN()
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal(err)
	}
	{
		rows, err := db.Query("select cast('2022-11-01 10:00:00' as datetime)")
		if err != nil {
			log.Fatal(err)
		}
		for rows.Next() {
			var t time.Time
			err := rows.Scan(&t)
			if err != nil {
				log.Fatal(err)
			}
			fmt.Println(t.Format(time.RFC3339)) // 2022-11-01T10:00:00+09:00
		}
	}
	{
		t, err := time.Parse(time.RFC3339, "2022-11-01T10:00:00Z")
		if err != nil {
			log.Fatal(err)
		}
		rows, err := db.Query("select ?", t)
		if err != nil {
			log.Fatal(err)
		}
		for rows.Next() {
			var tt string
			err := rows.Scan(&tt)
			if err != nil {
				log.Fatal(err)
			}
			fmt.Println(tt) // 2022-11-01 19:00:00
		}
	}
}
