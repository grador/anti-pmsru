# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# set :output, "/path/to/my/cron_log.log"
# TODO сменить environment перед деплоем
set :environment, 'production'
# set :environment, 'development'

# every 6.hours do
every 2.hours do
  runner "HardWorker.perform_async"
end
