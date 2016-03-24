lock '3.4.0'

set :application, 'slashpvp'
set :repo_url, 'git@github.com:dplatte/slashpvp.git'

set :stages, %w(staging production)
set :default_stage, "production"

set :ssh_options, {
  forward_agent: true,
  auth_methods: ["publickey"],
  keys: ["~/.ssh/MacbookPro.pem"]
}

set :pty, true

set :deploy_to, '/home/deploy/slashpvp'
set :rails_env, "production"

set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.2.1'

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

# namespace :deploy do
#   desc "Update crontab with whenever"
#   task :update_cron do
#     on roles(:app) do
#       within current_path do
#         execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
#       end
#     end
#   end

#   after :finishing, 'deploy:update_cron'
# end
