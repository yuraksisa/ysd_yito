require 'ysd_md_logger' unless defined?Model::LogDeviceInverseProxy
require 'dm-core' unless defined?DataMapper
require 'ysd-persistence' unless defined?Persistence
require 'ysd_service_postal' unless defined?PostalService

# ------------------------------------------------
# - It's the development environment configuration
# ------------------------------------------------
  
  # ----- LOGGER configuration --------
     
  Model::LogDeviceInverseProxy.instance.register_logdevice($stdout)

  logger = ::Logger.new(Model::LogDeviceInverseProxy.instance)
  logger.level = Logger::DEBUG #ERROR #DEBUG
  logger.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} [#{severity}] #{progname} #{msg}\n"
  end
          
  # --- DATA ACCESS CONFIGURATION ----

  # MONGODB http://docs.mongodb.org/manual/tutorial/control-access-to-mongodb-with-authentication/

  # DATABASE configuration

  DataMapper::Logger.new($stdout, :error) 
  DataMapper.setup(:default, {:adapter => 'postgres',:database => 'mydb',:host => 'localhost',:username => 'myuser',:password => 'mypassword'})
  DataMapper::Model.raise_on_save_failure = true 
  DataMapper.finalize
      
  # Persistence service
  # Connect to your database
  # mongo host/admin
  # use admin
  # db.addUser("<username>", "<password>")
  Persistence.logger = logger
  Persistence.setup(:default, { :adapter => 'mongodb', :host => 'localhost', :port => '27017', :database => 'mydb', :username => 'myuser', :password => 'mypassword' })
 
  
#  Load the contents from the folder contents
#  Persistence.setup(:default, {:adapter=>'memory'})
#  ResourceLoader.instance.load_files(ContentManagerSystem::Content, File.join(File.dirname(File.expand_path(__FILE__)),'data/persistence/content'))     
#  ResourceLoader.instance.load_files(Users::Profile, File.join(File.dirname(File.expand_path(__FILE__)),'data/persistence/user')) 
  
  # --- OTHER ENVIRONMENT CONFIGURATIONS ----
  
  # Postal service
  PostalService.account(:default, {:via => :smtp, :via_options => {:address => 'smtp.gmail.com', :port => '587', :user_name => 'yurak.sisa.customers' , :password => 'chiriyuyo', :enable_starttls_auto => true, :domain => 'localhost@localdomain', :authentication => :plain }})
  PostalService.setup( :enable_tls => true )
