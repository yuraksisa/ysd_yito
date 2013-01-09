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

# Rack
use Rack::Session::Cookie
use Rack::Logger 

# Warden configuration 

Warden::Strategies.add(:profile_strategy, ProfileWarden::ProfileWardenStrategy)
Warden::Strategies.add(:anonymous_strategy, WardenStrategy::AnonymousWardenStrategy)

use Warden::Manager do |config|
  config.failure_app = Sinatra::Yito
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
           Users::Profile.get(username) || Users::Profile::ANONYMOUS_USER
         end
end
  
# ------- Start the application -------------

#MIME::Types.add(MIME::Type.from_array("video/mp4", %(m4v)))

require './config/aspects.rb' 
require './my_web.rb'


Sinatra::Yito.use Middleware::RequestLanguage 

run Sinatra::MyWeb
