ENV['RAILS_ENV'] = 'production'

ENV['RAILS_SERVE_STATIC_FILES'] = true

worker_processes 1  # количество воркер процессов, я люблю делать их по кол-ву ядер например
preload_app true
user('deployer','staff')  # здесь указываем пользователя и группу его
timeout 30 # таймаут работы приложения

@app = "/home/deployer/websites/coreearth_main/current"  # путь к нашему размещенному приложению, разумеется project_name меняем на ваш везде
@shared = "/home/deployer/websites/coreearth_main/shared"  # путь к shared папке

listen "#{@shared}/tmp/unicorn.socket"  # путь где будет лежать открытый Unicorn
working_directory "#{@app}"
pid "#{@shared}/tmp/unicorn.pid"  # ключ инстанса нашего запущенного сервера
stderr_path "#{@shared}/log/unicorn.stderr.log"  # пути к логам unicorn'а
stdout_path "#{@shared}/log/unicorn.stdout.log"

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  Rails.cache.reset if Rails.cache.respond_to? :reset
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end