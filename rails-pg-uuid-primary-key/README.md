# Rails PostgreSQL UUID primary key

## Dependencies

- Ruby: 3.x
- Rails: 7.x
- PostgreSQL: 15.x
- Docker
- Docker Compose

## Setup

```sh
docker compose run --rm app bundle
docker compose run --rm app rails db:setup
docker compose up
open http://localhost:3000
```

## How to introduce UUID v4 to primary key

**config/application.rb:**

```rb
module RailsPgUuidPrimaryKey
  class Application < Rails::Application
    ...
+    config.generators do |g|
+      g.orm :active_record, primary_key_type: :uuid
+    end
  end
end
```

**db/migrate/00000000000000_create_users.rb:**

```rb
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      ...
      t.timestamps
+      t.index :created_at
    end
  end
end
```

**app/models/user.rb:**

```rb
class User < ApplicationRecord
+  self.implicit_order_column = :created_at
+  scope :oldest, -> { order(created_at: :asc) }
+  scope :latest, -> { order(created_at: :desc) }
end
```

**app/controllers/users_controller.rb:**

```rb
class UsersController < ApplicationController
  ...

  def index
-    @users = User.all
+    @users = User.all.oldest
  end
```

## References

- [Docker の公式 PostgreSQL イメージでの HEALTHCHECK 指定方法まとめ | gotohayato.com](https://gotohayato.com/content/562/)
- [UUID主キーをActiveRecordで使う（PostgreSQL 13+）](https://zenn.dev/takeyuwebinc/articles/e7fb82a276ba76)
- [Rails6 のちょい足しな新機能を試す71（implict_order_column 編） #Ruby - Qiita](https://qiita.com/suketa/items/932f47dbbecd55d7f58d)
- [Postgres と MySQL における id, created_at, updated_at に関するベストプラクティス](https://zenn.dev/mpyw/articles/rdb-ids-and-timestamps-best-practices)
- [Docker の公式 PostgreSQL イメージでの HEALTHCHECK 指定方法まとめ | gotohayato.com](https://gotohayato.com/content/562/)
