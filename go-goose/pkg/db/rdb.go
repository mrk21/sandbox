package db

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/go-sql-driver/mysql"
)

func GetRDBInfo() (string, string) {
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	user := os.Getenv("DB_USER")
	pass := os.Getenv("DB_PASS")
	db := "go-goose_development"
	addr := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", user, pass, host, port, db)
	return "mysql", addr
}

func OpenRDB() (*sql.DB, error) {
	conn, err := sql.Open(GetRDBInfo())
	return conn, err
}
