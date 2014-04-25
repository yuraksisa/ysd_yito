require 'rubygems'
require 'sinatra/base'
require 'sinatra/r18n'
require 'ysd_yito_core'
require 'ysd_yito_js'
require 'sinatra/ysd_sinatra_site'

module Sinatra

  #
  # The web application
  #
  class Yito < Sinatra::Base

    helpers  Sinatra::RequestLanguageHelper  
    register Sinatra::R18n 
    register Sinatra::YSD::Errors 

    enable :logging

    # Configuration 
    configure do  
      class_eval File.read('./config/application.rb'), __FILE__, __LINE__
    end
  
    configure :development do
      enable :raise_errors
      class_eval File.read('./config/environments/development.rb'), __FILE__, __LINE__   
    end
  
    configure :production do
      class_eval File.read('./config/environments/production.rb'), __FILE__, __LINE__
    end
    
    # Plugin extension (the sinatra extension which loads the modules) 
    register Sinatra::YSD::PluginExtension 
    register Sinatra::YSD::Site

    # Register the logger
    Model::LogDeviceInverseProxy.instance.register_logdevice(Model::LogDevice.new)
    
    # Before any request
    before do
      # configure logger
      logger = ::Logger.new(Model::LogDeviceInverseProxy.instance)
      logger.level = Logger::INFO
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}] #{progname} #{msg}\n"
      end
      env['rack.logger'] = logger          
      #
      Plugins::Plugin.plugin_invoke_all('aspects', {:app => self}) #TODO solve
      # Configure the theme
      theme=SystemConfiguration::Variable.get_value('site.theme','default')
      Themes::ThemeManager.instance.select_theme(theme.to_sym)
    end

    # Before any request (except /login and /logout)
    before /^(?!(\/.*login|\/.*logout|\/.*unauthenticated))/ do
      if not authenticated?
        authenticate # Force the authentication (always the anonymous user)
      end
    end

  end # class YurakWeb

end # module Sinatra

