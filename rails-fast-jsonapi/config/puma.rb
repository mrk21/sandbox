require 'ostruct'
require 'pathname'
require 'pp'

config = OpenStruct.new \
  root: Pathname.new(__dir__).join('..').expand_path,
  port: ENV.fetch('PORT', 3000).to_i,
  workers: ENV.fetch('WEB_CONCURRENCY', 0).to_i,
  threads: ENV.fetch('RAILS_MAX_THREADS', 10).to_i,
  rails_env: ENV.fetch('RAILS_ENV', 'development')

pp config

workers config.workers if config.workers > 1
threads config.threads, config.threads
environment config.rails_env
pidfile "#{config.root}/tmp/pids/puma.pid"
state_path "#{config.root}/tmp/pids/puma.state"
bind "tcp://0.0.0.0:#{config.port}"

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
