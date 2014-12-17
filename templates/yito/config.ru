# ===============================================
# config.ru for running the RackApplication
# -----------------------------------------------
# It can be run using $rackup
# It's ready to be deployed in Heroku
# ===============================================
require 'rubygems'
    
# Bundler: Dependencies management    
    
require 'bundler/setup'
require 'bundler'
Bundler.require 

# App requires
require './config/aspects.rb'
require './config/business_events.rb' 
require './my_web.rb'

# Warden configuration 
Warden::Strategies.add(:profile_strategy, ProfileWarden::ProfileWardenStrategy)
Warden::Strategies.add(:anonymous_strategy, WardenStrategy::AnonymousWardenStrategy)

use Warden::Manager do |config|
  config.failure_app = Sinatra::MyWeb
  config.default_strategies :profile_strategy, :anonymous_strategy
end

Warden::Manager.serialize_into_session do |user|
  user.username
end

Warden::Manager.serialize_from_session do |id|
  username = if id.kind_of?(Users::Profile)
              id.username
            else
              id.to_s
            end
  user = if username and username.strip.length > 0            
           username == 'anonymous' ? Users::Profile.ANONYMOUS_USER : Users::Profile.get(username)
         end
end

# Rack
# Sessions are defined in sinatra app because the use of sinatra-flash
#use Rack::Session::Cookie, :secret => 'chiriyuyo'
use Rack::Logger 

#Unicorn worker killer
if ENV['RACK_ENV'] == :production
  require 'unicorn/worker_killer'
  max_request_min =  500
  max_request_max =  600

  # Max requests per worker
  use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max

  oom_min = (240) * (1024**2)
  oom_max = (260) * (1024**2)

  # Max memory size (RSS) per worker
  use Unicorn::WorkerKiller::Oom, oom_min, oom_max
end

# Cache
if memcachier_servers = ENV['MEMCACHIER_SERVERS']
  cache = Dalli::Client.new memcachier_servers.split(','), {
    :username => ENV['MEMCACHIER_USERNAME'],
    :password => ENV['MEMCACHIER_PASSWORD']
  }
  use Rack::Cache,
    :verbose => true,
    :metastore => cache,
    :entitystore => cache
else
  use Rack::Cache,
    :verbose => true,
    :metastore => 'file:./cache/meta',
    :entitystore => 'file:./cache/body'
end

run Sinatra::MyWeb
