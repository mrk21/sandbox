class Uuid7 < ActiveRecord::Migration[7.0]
  def up
    # @see https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
    execute <<~SQL
      create or replace function gen_uuid_v7()
      returns uuid
      as $$
      begin
        -- use random v4 uuid as starting point (which has the same variant we need)
        -- then overlay timestamp
        -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
        return encode(
          set_bit(
            set_bit(
              overlay(uuid_send(gen_random_uuid())
                      placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                      from 1 for 6
              ),
              52, 1
            ),
            53, 1
          ),
          'hex')::uuid;
      end
      $$
      language plpgsql
      volatile;
    SQL

    # @see https://zenn.dev/mpyw/articles/rdb-ids-and-timestamps-best-practices
    execute <<~SQL
      create or replace function is_uuid_v7(val uuid)
      returns boolean
      as $$
      begin
        return get_byte(uuid_send($1), 6) >> 4 = 7;
      end
      $$
      language plpgsql
      volatile;

      create or replace function is_uuid_v4(val uuid)
      returns boolean
      as $$
      begin
        return get_byte(uuid_send($1), 6) >> 4 = 4;
      end
      $$
      language plpgsql
      volatile;
    SQL

    # @see https://zenn.dev/mpyw/articles/rdb-ids-and-timestamps-best-practices
    execute <<~SQL
      CREATE OR REPLACE FUNCTION min(uuid, uuid) RETURNS uuid AS
      $$
      BEGIN
          return LEAST($1, $2);
      END
      $$ LANGUAGE plpgsql IMMUTABLE PARALLEL SAFE;

      CREATE OR REPLACE FUNCTION max(uuid, uuid) RETURNS uuid AS
      $$
      BEGIN
          return GREATEST($1, $2);
      END
      $$ LANGUAGE plpgsql IMMUTABLE PARALLEL SAFE;

      CREATE OR REPLACE AGGREGATE min(uuid) (
          sfunc = min,
          stype = uuid,
          combinefunc = min,
          parallel = safe,
          sortop = operator (<)
      );

      CREATE OR REPLACE AGGREGATE max(uuid) (
          sfunc = max,
          stype = uuid,
          combinefunc = max,
          parallel = safe,
          sortop = operator (>)
      );
    SQL
  end

  def down
    execute 'DROP FUNCTION gen_uuid_v7()'
    execute 'DROP FUNCTION is_uuid_v7(uuid)'
    execute 'DROP FUNCTION is_uuid_v4(uuid)'
    execute 'DROP AGGREGATE IF EXISTS max(uuid)'
    execute 'DROP AGGREGATE IF EXISTS min(uuid)'
    execute 'DROP FUNCTION IF EXISTS max(uuid, uuid)'
    execute 'DROP FUNCTION IF EXISTS min(uuid, uuid)'
  end
end
