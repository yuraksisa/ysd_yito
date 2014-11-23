require 'sinatra/yito_web'

module Sinatra

  #
  # The web application
  #
  class MyWeb < Sinatra::Yito
   
     set :session_secret, 'chiriyuyo'
     enable :sessions
   
     set :protection, :except => [:frame_options]

     #Middleware::RequestLanguage.set :protection, :except => [:frame_options]
     #use Middleware::RequestLanguage 

     # You can define your own routes HERE

     # If you use newrelic
     # configure :production do
     #  require 'newrelic_rpm'
     # end



  end # class YurakWeb

end # module Sinatra

