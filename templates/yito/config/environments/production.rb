require 'uri' 
require 'ysd_md_logger' unless defined?Model::LogDeviceInverseProxy
require 'dm-core' unless defined?DataMapper
require 'ysd-persistence' unless defined?Persistence
require 'ysd_service_postal' unless defined?PostalService

#
# It's the production environment configuration
#

  # ----- LOGGER configuration --------
          
  Model::LogDeviceInverseProxy.instance.register_logdevice($stdout)

  logger = ::Logger.new(Model::LogDeviceInverseProxy.instance)
  logger.level = Logger::ERROR
  logger.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}] #{progname} #{msg}\n"
  end

    # --- DATA ACCESS CONFIGURATION ----
  
  postgres_uri = ENV['DATABASE_URL']
  mongodb_uri  = URI.parse(ENV['MONGOLAB_URI'])

  # DATABASE configuration

  DataMapper::Logger.new($stdout, :error) #:debug)
  DataMapper.setup(:default, postgres_uri)
  DataMapper::Model.raise_on_save_failure = true
  DataMapper.finalize 

  # Persistence service

  Persistence.logger = logger  
  Persistence.setup(:default, {:adapter => 'mongodb', :host => mongodb_uri.host, :port => mongodb_uri.port, :database => mongodb_uri.path.sub('/',''), :username => mongodb_uri.user, :password => mongodb_uri.password })    
 
  # Postal service
  PostalService.account(:default, {:via => :smtp, :via_options => {:address => 'smtp.gmail.com', :port => '587', :user_name => 'yurak.sisa.customers' , :password => 'chiriyuyo', :enable_starttls_auto => true, :domain => 'localhost@localdomain', :authentication => :plain }})
  PostalService.setup( :enable_tls => true )
  
  
