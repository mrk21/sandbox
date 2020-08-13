class MigrationReporter
  attr_reader :logger

  def init
    path.root.rmtree if path.root.exist?
    path.root.mkdir
    migration_context.schema_migration.create_table

    @state = OpenStruct.new
    @failure_migrations = []

    @default_logger = ActiveRecord::Base.logger
    @logger = Logger.new(path.log)
    @logger.level = Logger::DEBUG
    @logger.extend ActiveSupport::Logger.broadcast(@default_logger)
  end

  def collect_before_state
    collect_status(:before)
    collect_schema(:before)
  end

  def collect_after_state
    collect_status(:after)
    collect_schema(:after)
  end

  def register_failure(version)
    m = migration_context.migrations.find { |m| m.version == version }
    @failure_migrations.push(m)
  end

  def start_logging
    ActiveRecord::Base.logger = @logger
  end

  def stop_logging
    ActiveRecord::Base.logger = @default_logger
  end

  def report
    path.report.open('w') do |io|
      io.puts '# Migration Report'
      io.puts ''

      io.puts '## Before Status'
      io.puts ''
      io.puts '```'
      io.puts status_table(:before)
      io.puts '```'
      io.puts ''

      io.puts '## After Status'
      io.puts ''
      io.puts '```'
      io.puts status_table(:after)
      io.puts '```'
      io.puts ''

      io.puts '## Applied Migrations'
      io.puts ''
      io.puts applied_migrations.map { |v| '* ' + v.filename }.join("\n")
      io.puts ''

      unless @failure_migrations.empty?
        io.puts '## Failure Migrations'
        io.puts ''
        io.puts @failure_migrations.map { |v| '* ' + v.filename }.join("\n")
        io.puts ''
      end

      io.puts '## Schema diff'
      io.puts ''
      io.puts '```'
      io.puts schema_diff
      io.puts '```'
    end

    if ENV['SLACK_WEBHOOK_URL'].present? && schema_diff.present?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping path.report.read
    end
  end

  module MigrationContextHook
    # @see Original https://github.com/rails/rails/blob/v6.0.3/activerecord/lib/active_record/migration.rb#L1054-L1062
    def up(target_version = nil)
      reporter = Thread.current['MigrationReporter'] = MigrationReporter.new
      reporter.init
      reporter.collect_before_state
      reporter.start_logging
      super
    ensure
      reporter.stop_logging
      reporter.collect_after_state
      reporter.report
    end
  end

  module MigrationProxyHook
    # @see Original https://github.com/rails/rails/blob/v6.0.3/activerecord/lib/active_record/migration.rb#L1002
    # @see https://github.com/rails/rails/blob/v6.0.3/activerecord/lib/active_record/migration.rb#L801-L820
    def migrate(direction)
      super
    rescue => e
      reporter = Thread.current['MigrationReporter']
      if reporter.present?
        reporter.logger.error [e.inspect, *e.backtrace].join("\n")
        reporter.register_failure(version)
      end
      raise
    end
  end

  private

  def migration_context
    ActiveRecord::Base.connection.migration_context
  end

  def path
    return @path unless @path.nil?
    root = Rails.root.join('tmp','migration_reporter')
    @path = OpenStruct.new(
      root: root,
      log: root.join('migration.log'),
      report: root.join('report.md'),
      schema: OpenStruct.new(
        before: root.join("schema_before.rb"),
        after: root.join("schema_after.rb"),
      )
    )
  end

  def collect_status(type)
    @state[type] = OpenStruct.new(
      status: migration_context.migrations_status,
      pendings: migration_context.open.pending_migrations,
    )
  end

  def collect_schema(type)
    require "active_record/schema_dumper"
    path.schema[type].open('w:utf-8') do |f|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, f)
    end
  end

  def status_table(type)
    @state[type].status.map { |v| v.join("\t") }.join("\n")
  end

  def applied_migrations
    m1 = @state.before.pendings
    m2 = @state.after.pendings
    mdiff = (m1 | m2) - (m1 & m2)
    mdiff.sort_by(&:version)
  end

  def schema_diff
    `diff #{path.schema.before} #{path.schema.after}`
  end
end

namespace :migration_reporter do
  task :inject_hooks do
    ActiveRecord::MigrationContext.prepend MigrationReporter::MigrationContextHook
    ActiveRecord::MigrationProxy.prepend MigrationReporter::MigrationProxyHook
  end
end

Rake::Task["db:migrate"].enhance(['migration_reporter:inject_hooks'])
