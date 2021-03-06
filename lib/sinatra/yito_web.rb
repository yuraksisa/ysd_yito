require 'rubygems'
require 'sinatra/base'
require 'sinatra/r18n'
require 'ysd_yito_core'
require 'sinatra/ysd_sinatra_site'
require 'sinatra/multi_route'

module Sinatra

  #
  # The web application
  #
  class Yito < Sinatra::Base

    helpers  Sinatra::RequestLanguageHelper  
    register Sinatra::LanguageExtract
    register Sinatra::R18n 
    register Sinatra::YSD::Errors 
    register Sinatra::MultiRoute

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
    
    Encoding.default_external=Encoding::UTF_8

    # Plugin extension (the sinatra extension which loads the modules) 
    register Sinatra::YSD::PluginExtension 
    register Sinatra::YSD::Site

    # Register the logger
    Model::LogDeviceInverseProxy.instance.register_logdevice(Model::LogDevice.new)
    
    # Before any request
    before do
      #p "START-REQUEST:#{request.path_info}"
      # configure logger
      logger = ::Logger.new(Model::LogDeviceInverseProxy.instance)
      logger.level = Logger::INFO
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}] #{progname} #{msg}\n"
      end
      env['rack.logger'] = logger         
      unless request.path_info =~ /^\/api/
        Plugins::Plugin.plugin_invoke_all('aspects', {:app => self}) #TODO solve
        # [NOTE 2019.01.22] There is just a back-end theme
        Themes::ThemeManager.instance.select_theme(:default)
        #theme=SystemConfiguration::Variable.get_value('site.theme','default')
        #Themes::ThemeManager.instance.select_theme(theme.to_sym)
      end
    end

    # Before any request (except /login and /logout)
    before /^(?!(\/.*login|\/.*logout|\/.*unauthenticated))/ do
      if not authenticated?
        p "User not authenticated"
        authenticate # Force the authentication (always the anonymous user)
      else
        p "Authenticated #{user.username}"
      end
    end

  end # class YurakWeb

end # module Sinatra

