package main

import (
	"database/sql"
	"database/sql/driver"
	"fmt"
	"log"
	"time"

	"github.com/go-sql-driver/mysql"
)

const RFC3339Date = "2006-01-02"

// Date without time zone
type Date struct {
	year  int
	month time.Month
	day   int
}

func NewDate(year int, month time.Month, day int) *Date {
	t := time.Date(year, month, day, 0, 0, 0, 0, time.UTC)
	return &Date{
		year:  t.Year(),
		month: t.Month(),
		day:   t.Day(),
	}
}

func (d *Date) Year() int {
	return d.year
}

func (d *Date) Month() time.Month {
	return d.month
}

func (d *Date) Day() int {
	return d.day
}

func (d *Date) Format(layout string) string {
	return d.Time(nil).Format(layout)
}

func (d *Date) Time(loc *time.Location) time.Time {
	if loc == nil {
		loc = time.Local
	}
	return time.Date(d.year, d.month, d.day, 0, 0, 0, 0, loc)
}

// Go => MySQL
func (d Date) Value() (driver.Value, error) {
	return driver.Value(d.Format(RFC3339Date)), nil
}

// MySQL => Go
func (d *Date) Scan(value interface{}) error {
	var t mysql.NullTime
	err := t.Scan(value)
	if err != nil {
		return err
	}
	d.day = t.Time.Day()
	d.month = t.Time.Month()
	d.year = t.Time.Year()
	return nil
}

// interface check
var _ driver.Valuer = (*Date)(nil)
var _ sql.Scanner = (*Date)(nil)

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
	init := func() {
		_, err := db.Exec("drop table if exists test_date")
		if err != nil {
			log.Fatal(err)
		}

		_, err = db.Exec("create table test_date(dt date)")
		if err != nil {
			log.Fatal(err)
		}
	}
	{
		init()
		date1 := time.Date(2022, 11, 2, 0, 0, 0, 0, time.UTC)

		_, err = db.Exec("insert into test_date(dt) values (?)", date1)
		if err != nil {
			log.Fatal(err)
		}

		rows, err := db.Query("select dt from test_date")
		if err != nil {
			log.Fatal(err)
		}

		var date2 time.Time
		for rows.Next() {
			rows.Scan(&date2)
			break
		}
		// date1: 2022-11-02(2022-11-02T00:00:00Z), date2: 2022-11-01(2022-11-01T15:00:00Z)
		fmt.Printf("date1: %s(%s), date2: %s(%s)\n",
			date1.UTC().Format(RFC3339Date),
			date1.UTC().Format(time.RFC3339),
			date2.UTC().Format(RFC3339Date),
			date2.UTC().Format(time.RFC3339),
		)
	}
	{
		init()
		date1 := NewDate(2022, 11, 2)

		_, err = db.Exec("insert into test_date(dt) values (?)", date1)
		if err != nil {
			log.Fatal(err)
		}

		rows, err := db.Query("select dt from test_date")
		if err != nil {
			log.Fatal(err)
		}

		var date2 Date
		for rows.Next() {
			rows.Scan(&date2)
			break
		}
		// date1: 2022-11-02, date2: 2022-11-02
		fmt.Printf("date1: %s, date2: %s\n",
			date1.Format(RFC3339Date),
			date2.Format(RFC3339Date),
		)
	}
}
