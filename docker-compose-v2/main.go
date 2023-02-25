package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

	"github.com/go-sql-driver/mysql"
)

type Hoge struct {
	ID    int    `json:"id"`
	Value string `json:"value"`
}

func main() {
	log.Println("booting...")

	conf := mysql.Config{
		User:      "root",
		Passwd:    "",
		Net:       "tcp",
		Addr:      "db:3306",
		DBName:    "app",
		Collation: "utf8mb4_bin",
	}
	dsn := conf.FormatDSN()
	log.Println(dsn)
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Panicln(err)
	}
	defer db.Close()

	_, err = db.Exec(`create table if not exists hoge(id bigint not null auto_increment primary key, value varchar(255));`)
	if err != nil {
		log.Panicln(err)
	}
	_, err = db.Exec(`insert into hoge(value) values ("a"), ("b")`)
	if err != nil {
		log.Panicln(err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		rows, err := db.Query(`select id, value from hoge`)
		if err != nil {
			w.Write([]byte(err.Error()))
			return
		}
		for rows.Next() {
			record := &Hoge{}
			err := rows.Scan(&record.ID, &record.Value)
			if err != nil {
				w.Write([]byte(err.Error()))
				return
			}
			json, err := json.Marshal(record)
			if err != nil {
				w.Write([]byte(err.Error()))
				return
			}
			w.Write(json)
			w.Write([]byte("\n"))
		}
	})

	err = http.ListenAndServe(":8080", nil)
	log.Fatalln(err)
}
