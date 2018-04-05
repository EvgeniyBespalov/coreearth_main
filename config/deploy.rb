require "rvm/capistrano"
require "bundler/capistrano"
load 'deploy/assets'

set :application, "coreearth_main" # название проекта, будет распологаться /home/deployer/project_name

set :scm, :git
set :repository,  "/home/action/projects/rails/coreearth_main/.git"  # в моем случае ссылки к репозитарию нет
set :deploy_via, :copy # и мы развертываем простым копированием
set :copy_cache, true

set :deploy_server,   "coreearth.work" # здесь IP или host нашего сервера для развертывания
set :bundle_without,  [:development, :test] # указываем какие среды не берем с собой на сервер

set :user,     "deployer"  # наш пользователь
set :group,    "staff"  # его группа
set :password, "ghb,kb;tybtdjhjnf"  # пароль от пользователя deployer
set :use_sudo, false  # в debian нам это не надо, в ubuntu может и включить прийдется

set :deploy_to,       "/home/#{user}/websites/#{application}"  # наша папка куда мы размещаем /home/deployer/project_name
set :bundle_dir,      File.join(fetch(:shared_path), 'gems')
role :web,            deploy_server  # наши сервера, так как он один, то на всех
role :app,            deploy_server
role :db,             deploy_server, :primary => true

ssh_options[:forward_agent] = true # тут "магия" по поводу если вы используете ключи и делаете sudo
set :ssh_options, {:forward_agent => true}
set :normalize_asset_timestamps, false

set :rvm_ruby_string, "2.1.10"  # здесь версия нашего ruby и созданного gemset'а, может его и надо будет создать
set :rvm_type, :system
set :rails_env, 'production'

set :rake,            "rvm use #{rvm_ruby_string} do bundle exec rake --trace"
set :bundle_cmd,      "rvm use #{rvm_ruby_string} do bundle"

task :set_current_release, :roles => :app do
  set :current_release, latest_release
end

set :unicorn_conf,    "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid,     "#{deploy_to}/shared/tmp/unicorn.pid"  # путь к нашему unicorn инстансу
set :unicorn_start_cmd, "(cd #{deploy_to}/current; rvm use #{rvm_ruby_string} do bundle exec unicorn_rails -Dc #{unicorn_conf})"  # команда для его запуска

# описания наших задачек для загрузки данных в базу и рестартов unicorn сервера
namespace :deploy do



  desc "reload the database with seed data"
  task :seed do
    run "cd #{deploy_to}/current; rvm use #{rvm_ruby_string} do bundle exec rake db:seed RAILS_ENV=production"
  end

  desc "Start application"
  task :start, :roles => :app do
    run unicorn_start_cmd
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_start_cmd}"
  end
end