namespace :uuid_pk do
  insert_data = ->(model_clazz, n) do
    model_clazz.insert_all(n.times.map{|i| { name: "User name #{i+1}" } })
  end

  desc 'Benchmark'
  task bench: [:bench_insert, :bench_select_by_id, :bench_select_all] do |t|
  end

  desc 'Benchmark insert'
  task bench_insert: :environment do |t|
    User.delete_all
    User2.delete_all
    User3.delete_all

    n = 500_000
    Benchmark.bm(1) do |x|
      x.report("User(UUID v4): insert") do
        insert_data.call(User, n)
      end
      x.report("User2(UUID v7): insert") do
        insert_data.call(User2, n)
      end
      x.report("User3(auto increment): insert") do
        insert_data.call(User3, n)
      end
    end
  end

  desc 'Benchmark select by id'
  task bench_select_by_id: :environment do |t|
    User.delete_all
    User2.delete_all
    User3.delete_all

    m = 100_000
    insert_data.call(User, m)
    insert_data.call(User2, m)
    insert_data.call(User3, m)

    n = 10_000
    user_id = User.last.id
    user2_id = User2.last.id
    user3_id = User3.last.id

    Benchmark.bm(1) do |x|
      x.report("User(UUID v4): select by id") do
        n.times do
          sql = "select * from users where id = :id"
          query = ActiveRecord::Base.sanitize_sql_array([sql, { id: user_id }])
          ActiveRecord::Base.connection.select_all(query)
        end
      end
      x.report("User2(UUID v7): select by id") do
        n.times do
          sql = "select * from user2s where id = :id"
          query = ActiveRecord::Base.sanitize_sql_array([sql, { id: user2_id }])
          ActiveRecord::Base.connection.select_all(query)
        end
      end
      x.report("User3(auto increment): select by id") do
        n.times do
          sql = "select * from user3s where id = :id"
          query = ActiveRecord::Base.sanitize_sql_array([sql, { id: user3_id }])
          ActiveRecord::Base.connection.select_all(query)
        end
      end
    end
  end

  desc 'Benchmark select all order by created'
  task bench_select_all: :environment do |t|
    User.delete_all
    User2.delete_all
    User3.delete_all

    m = 100_000
    insert_data.call(User, m)
    insert_data.call(User2, m)
    insert_data.call(User3, m)

    n = 100
    Benchmark.bm(1) do |x|
      x.report("User(UUID v4): select all order by created_at") do
        n.times do
          ActiveRecord::Base.connection.select_all("select * from users order by created_at asc")
        end
      end
      x.report("User2(UUID v7): select all order by id") do
        n.times do
          ActiveRecord::Base.connection.select_all("select * from user2s order by id asc")
        end
      end
      x.report("User3(auto increment): select all order by id") do
        n.times do
          ActiveRecord::Base.connection.select_all("select * from user3s order by id asc")
        end
      end
    end
  end
end
