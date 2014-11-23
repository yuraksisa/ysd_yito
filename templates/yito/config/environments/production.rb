require 'uri' 
require 'base64'
require 'ysd_md_logger' unless defined?Model::LogDeviceInverseProxy
require 'dm-core' unless defined?DataMapper
require 'ysd-persistence' unless defined?Persistence
require 'ysd_service_postal' unless defined?PostalService
require 'dm-ysd-encrypted' unless defined?Crypto

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

  # DATABASE configuration

  DataMapper::Logger.new($stdout, :error) #:debug)
  DataMapper.setup(:default, postgres_uri)
  DataMapper::Model.raise_on_save_failure = true
  DataMapper.finalize 
 
  #
  # Crypt configuration using three environment variables:
  #
  #  - CRYPT_RSA_KEY Public RSA key used to encrypt the AES_KEY
  #  - CRYPT_AES_KEY A 256 bits AES_KEY encrypted with CRYPT_RSA_KEY
  #  - CRYPT_AES_IV The IV (necessary for AES_KEY) encrypted with CRYPT_RSA_KEY
  #
  # Howto setup keys on heroku
  #
  # 1. Create the keys
  #
  #  $irb
  #  > require 'openssl'
  #  > require 'base64'
  #  > require 'digest/sha2'
  #
  #  CRYPT RSA KEY
  #  > rsa_key=OpenSSL::PKey::RSA.generate(2048)
  #  .to_pem para importar en heroku
  #  
  #  CRYPT_AES_KEY 
  #  > Base64.encode64(rsa_key.public_encrypt(Digest::SHA2.new(256).digest('my-password'))) 
  #
  #  CRYPT_AES_IV
  #  > Base64.encode64(rsa_key.public_encrypt(rand.to_s))      
  # 
  # 2. Register keys on Heroku
  #
  #  $heroku config:set CRYPT_RSA_KEY=  
  #  $heroku config:set CRYPT_AES_KEY=
  #  $heroku config:set CRYPT_AES_IV=
  #
  # Then, you can use in the program 
  #
  Crypto.configure(:rsa_key => ENV['CRYPT_RSA_KEY'].gsub("\\n","\n"),
    :aes_key => Base64.decode64(ENV['CRYPT_AES_KEY'].gsub("\\n","\n")),
    :aes_iv => Base64.decode64(ENV['CRYPT_AES_IV'].gsub("\\n","\n")))

  # Postal service
  PostalService.account(:default, {:via => :smtp, :via_options => {:address => 'smtp.gmail.com', :port => '587', :user_name => 'yurak.sisa.customers' , :password => 'chiriyuyo', :enable_starttls_auto => true, :domain => 'localhost@localdomain', :authentication => :plain }})
  PostalService.setup( :enable_tls => true )
  
  
