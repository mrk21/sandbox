// @see https://github.com/pressly/goose/blob/v2.6.0/examples/go-migrations/main.go
package main

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"os"

	_ "github.com/mrk21/sandbox/go-goose/db/migration"
	"github.com/mrk21/sandbox/go-goose/pkg/db"
	"github.com/pressly/goose"
)

var (
	flags   = flag.NewFlagSet("goose", flag.ExitOnError)
	verbose = flags.Bool("v", false, "enable verbose mode")
	help    = flags.Bool("h", false, "print help")
	version = flags.Bool("version", false, "print version")
	dir     = "db/migration"
)

func main() {
	flags.Parse(os.Args[1:])
	args := flags.Args()

	if *verbose {
		goose.SetVerbose(true)
	}
	if *help {
		usage()
		return
	}
	if *version {
		fmt.Println(goose.VERSION)
		return
	}
	if len(args) < 1 {
		usage()
		return
	}

	arguments := []string{}
	if len(args) > 1 {
		arguments = append(arguments, args[1:]...)
	}
	command := args[0]

	dialect, addr := db.GetRDBInfo()
	goose.SetDialect(dialect)
	conn, err := sql.Open(dialect, addr)
	if err != nil {
		log.Fatalf("goose run: %v", err)
	}
	defer conn.Close()

	err = goose.Run(command, conn, dir, arguments...)
	if err != nil {
		log.Fatalf("goose run: %v", err)
	}
}

func usage() {
	fmt.Println(usagePrefix)
	flags.PrintDefaults()
	fmt.Println(usageCommands)
}

var (
	usagePrefix = `Usage: goose [OPTIONS] COMMAND
Options:
`
	usageCommands = `
Commands:
    up                   Migrate the DB to the most recent version available
    up-by-one            Migrate the DB up by 1
    up-to VERSION        Migrate the DB to a specific VERSION
    down                 Roll back the version by 1
    down-to VERSION      Roll back to a specific VERSION
    redo                 Re-run the latest migration
    reset                Roll back all migrations
    status               Dump the migration status for the current DB
    version              Print the current version of the database
    create NAME [sql|go] Creates new migration file with the current timestamp
    fix                  Apply sequential ordering to migrations
`
)
