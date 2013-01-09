worker_processes 2
preload_app true
timeout 30
#listen 3000

# DataMapper pools
before_fork do |w,s|
  DataObjects::Pooling.pools.each { |pool| pool.dispose }
end

