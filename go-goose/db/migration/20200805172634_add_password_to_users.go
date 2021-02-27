package migration

import (
	"database/sql"

	"github.com/pressly/goose"
)

func init() {
	goose.AddMigration(Up20200805172634, Down20200805172634)
}

func Up20200805172634(tx *sql.Tx) error {
	_, err := tx.Exec("ALTER TABLE `users` ADD `password` VARCHAR(255) NOT NULL;")
	if err != nil {
		return err
	}
	return nil
}

func Down20200805172634(tx *sql.Tx) error {
	_, err := tx.Exec("ALTER TABLE `users` DROP `password`;")
	if err != nil {
		return err
	}
	return nil
}
