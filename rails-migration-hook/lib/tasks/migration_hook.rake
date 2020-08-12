class MigrationReporter
  def self.get
    @@instance ||= new
  end

  def self.close
    return if @@instance.nil?
    @@instance.close
    @@instance = nil
  end

  def init
    path.root.rmtree if path.root.exist?
    path.root.mkdir
    migration_context.schema_migration.create_table
    @default_logger = ActiveRecord::Base.logger
    @state = OpenStruct.new
  end

  def close
    stop_logging
  end

  def collect_before_state
    collect_status(:before)
    collect_schema(:before)
  end

  def collect_after_state
    collect_status(:after)
    collect_schema(:after)
  end

  def start_logging
    @logger = Logger.new(path.log)
    @logger.level = Logger::DEBUG
    @logger.extend ActiveSupport::Logger.broadcast(@default_logger)
    ActiveRecord::Base.logger = @logger
  end

  def stop_logging
    ActiveRecord::Base.logger = @default_logger
  end

  def report
    puts '# Report'
    puts ''

    puts '## Before Status'
    puts ''
    puts '```'
    puts status_table(:before)
    puts '```'
    puts ''

    puts '## After Status'
    puts ''
    puts '```'
    puts status_table(:after)
    puts '```'
    puts ''

    puts '## Applied Migrations'
    puts ''
    puts applied_migrations.map { |v| '* ' + v }.join("\n")
    puts ''

    puts '## Schema diff'
    puts ''
    puts '```'
    puts schema_diff
    puts '```'
  end

  private

  def path
    return @path unless @path.nil?
    root = Rails.root.join('tmp','migration_reporter')
    @path = OpenStruct.new(
      root: root,
      log: root.join('migration.log'),
      schema: OpenStruct.new(
        before: root.join("schema_before.rb"),
        after: root.join("schema_after.rb"),
      )
    )
  end

  def migration_context
    ActiveRecord::Base.connection.migration_context
  end

  # @see https://github.com/rails/rails/blob/v6.0.3/activerecord/lib/active_record/tasks/database_tasks.rb#L232-L245
  # @see https://github.com/rails/rails/blob/v6.0.3/activerecord/lib/active_record/migration.rb#L1054-L1062
  def collect_status(type)
    @state[type] ||= OpenStruct.new(
      status: migration_context.migrations_status,
      pendings: migration_context.open.pending_migrations,
    )
  end

  def collect_schema(type)
    require "active_record/schema_dumper"
    path.schema[type].open('w') do |f|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, f)
    end
  end

  def status_table(type)
    @state[type][:status].map { |v| v.join("\t") }.join("\n")
  end

  def applied_migrations
    m1 = @state.before.pendings.map(&:filename)
    m2 = @state.after.pendings.map(&:filename)
    (m1 | m2) - (m1 & m2)
  end

  def schema_diff
    `diff #{path.schema.before} #{path.schema.after}`
  end
end

namespace :migration_hook do
  task :before_migrate do
    reporter = MigrationReporter.get
    reporter.init
    reporter.collect_before_state
    reporter.start_logging
  end

  task :after_migrate do
    reporter = MigrationReporter.get
    reporter.stop_logging
    reporter.collect_after_state
    reporter.report
    MigrationReporter.close
  end
end

Rake::Task["db:migrate"].enhance(['migration_hook:before_migrate']) do
  Rake::Task['migration_hook:after_migrate'].invoke
end
