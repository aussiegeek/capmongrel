unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano/ext/multistage requires Capistrano 2"
end

Capistrano::Configuration.instance.load do
  namespace :deploy do
    namespace :mongrel do
      [ :stop, :start, :restart ].each do |t|
        desc "#{t.to_s.capitalize} the mongrel appserver"
        task t, :roles => :app do
          run "mongrel_rails cluster::#{t.to_s} --clean -C #{deploy_to}/current/config/mongrel_cluster.yml"
        end
      end
    end

    desc "Custom restart task for mongrel cluster"
    task :restart, :roles => :app, :except => { :no_release => true } do
      deploy.mongrel.restart
    end

    desc "Custom start task for mongrel cluster"
    task :start, :roles => :app do
      deploy.mongrel.start
    end

    desc "Custom stop task for mongrel cluster"
    task :stop, :roles => :app do
      deploy.mongrel.stop
    end

    desc "Restart aapche"
    task :restart_apache, :roles => :app do
      sudo "/etc/init.d/apache2 restart"
    end
  end
end