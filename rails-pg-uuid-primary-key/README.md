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
+    config.generators.orm :active_record, primary_key_type: :uuid
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
+  scope :newest, -> { order(created_at: :desc) }
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

## How to introduce UUID v7 to primary key

**config/application.rb:**

```rb
module RailsPgUuidPrimaryKey
  class Application < Rails::Application
    ...
+    config.generators.orm :active_record, primary_key_type: :uuid
+    config.active_record.schema_format = :sql
  end
end
```

**db/migrate/00000000000000_create_users2.rb:**

```rb
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
+    execute <<~SQL
+      create or replace function gen_uuid_v7()
+      returns uuid
+      as $$
+      begin
+        -- use random v4 uuid as starting point (which has the same variant we need)
+        -- then overlay timestamp
+        -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
+        return encode(
+          set_bit(
+            set_bit(
+              overlay(uuid_send(gen_random_uuid())
+                      placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
+                      from 1 for 6
+              ),
+              52, 1
+            ),
+            53, 1
+          ),
+          'hex')::uuid;
+      end
+      $$
+      language plpgsql
+      volatile;
+    SQL

-    create_table :user2s, id: :uuid do |t|
+    create_table :user2s, id: :uuid, default: 'gen_uuid_v7()' do |t|
      ...
    end
  end
end
```

## References

- [Docker の公式 PostgreSQL イメージでの HEALTHCHECK 指定方法まとめ | gotohayato.com](https://gotohayato.com/content/562/)
- [UUID主キーをActiveRecordで使う（PostgreSQL 13+）](https://zenn.dev/takeyuwebinc/articles/e7fb82a276ba76)
- [Rails6 のちょい足しな新機能を試す71（implict_order_column 編） #Ruby - Qiita](https://qiita.com/suketa/items/932f47dbbecd55d7f58d)
- [Postgres と MySQL における id, created_at, updated_at に関するベストプラクティス](https://zenn.dev/mpyw/articles/rdb-ids-and-timestamps-best-practices)
- [Docker の公式 PostgreSQL イメージでの HEALTHCHECK 指定方法まとめ | gotohayato.com](https://gotohayato.com/content/562/)
- [Postgres PL/pgSQL function for UUID v7 and a bonus custom UUID v8 to support microsecond precision as well. Read more here: https://datatracker.ietf.org/doc/draft-peabody-dispatch-new-uuid-format/](https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74)
