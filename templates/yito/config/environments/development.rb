require 'ysd_md_logger' unless defined?Model::LogDeviceInverseProxy
require 'dm-core' unless defined?DataMapper
require 'ysd-persistence' unless defined?Persistence
require 'ysd_service_postal' unless defined?PostalService
require 'dm-ysd-encrypted' unless defined?Crypto

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
      
  #
  # Crypt configuration
  #
  Crypto.configure({:rsa_key => "-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEAuOpx5Nry3zWQkgxJtC3nPJCQ5lwZQVHaOuASYlWWhuzcKNx/\n5t86O+e6udsYGqDFq5vxL7HtPUUQQd7K8kEEqzJorhOiNbavM4U7yaxJXZSFwkcz\nhdYIgqIM27H4ob4/tIFnpKTZwh0dNELaZ4sa060aVBrrl/qu9LrJMmHbGMvD1FA2\nmJSxzBCN2VuQZ8U1ZQkcAXr5A08fpn64yfdemUaMhduHjmEZGPOgnL6sZmtNyiZV\n2dpDsp9mj1qy5W50PpmSSYlVBgIECroOydQf8wWTnvg7b7W2qv8sxatq5fdjLfQC\nGDKy8/sy31QGCmkQpKnnxe3hiZwBstmLwe8+pwIDAQABAoIBAQCVIgd/EhIkcLfL\nAfwDQ64li1ZBYu+/XXtKVmKdSfefk7Gvhr3kfg4iOC7BK/ERsK4bTCZFWBNEgcmt\nxjgZDtTsGTiRhCYjedVtELv6V2fIADusRu5Htymf6X/DQ5KJJ72LH35uK8Gvqvld\np7krHuYg54+/WwK8zKGDoI0ZhBBGuthnhn1+BUKC07/he/X2l+NHVQ02/PPsWIo/\ncxqymFYVvcWsTWXMK8KesqVOaZFFAegExgKM1rOnQtTNNg6w3yNK+dtb/XdJn0Uj\nfHDFW4xhQg9xPZ21EdHZ+sl5nDYdBq/O+mduY7YMknKI+k9NwjT+7FppWK+7Qgdr\nJmHFFsNxAoGBAOFf3NCiaR5zq2PfjL6K/i2IOBXvSILvs6PJX4mSWBHsOAXYecvM\ni6uo9WGOCi5JLN3vLR94innxUOb39cIeE3IS83zmPpbdJt2p3iMkCaJdzDpkvr6p\nceO4Vp1t45K8j18yYMDp0LOc8hNLBpHZBEMw7zACOLD9bovifM6E9jF5AoGBANIL\nI+/NrOhIxhjeHmP2Sx3k8TNsw4cL6yfSCJHYfzfW0om/ZiZw276NnUVdAnHKLFd6\n2bbGjYjkVj4liRA6P2A4SNm93DvJzkIBqwtKcTF+T/qB9x41NMpVFqxfXzBNL45v\nHokRihgZKIXZ7/vbe7LcZ3KiscURK37OrEEc8gkfAoGBAI5O37mFs+acly5bLB3s\n2g6aIwAGtbyn6sCTGRZfJ+k5RS67wDxljhP4fej5rYgIgKIqsk1a6eWR8MnG7JGE\nODchrEnDgOX2AuKYrkF2MfcqTxjYIHF3wQhPj7Gcf8RZ+BXeU6W8fiHMCjcQereB\nVuWucnnYDUAE5tbBTpmA74vRAoGANE+1+Yld4NQPEi5vnzG974oPUGFsKPwc6uPy\nYnBq7rs/4DKc/EHrWH/ohVfuvew+MuNTyaOVqFxF5mBuzG3VTt91tVUFvpY6GlJU\nCRHXMx5kSN2JcCqMJUAfz3pJOLxgdbbTAgwuOmY5o2xtymoVWqxtzy0Z3Ryzmnda\nizTsSr0CgYEAnHXdIkvuV2BvFwOzbXVQErLQL3llhyB1TpkdxPRfSQVWVRtH9n5K\nw9iMJhCl5UlDAew+UU/8rNCLif/9iZ3CSp4mHQUjX1gW9BQ2GReO0GlM5lyn/6xY\nfrfB6Cb75c+sjmpvxiMU09BwIA7NlB1Hk6S15WBK6+CJiHMeED5HXFk=\n-----END RSA PRIVATE KEY-----\n",
    :aes_key => "\x91^\x13\xB1i\xCB\xBC`P\xE0t\xFD\xAC\xBDx\x14\xF6\xBB\x1D(\xFF\xB4\x9C\xAB\xA94>Ly\xC2\xA1@\xD8{\xBAC\x0F@SZ\xAD\xA2.}1\x15\x1CZ:<\xEE\f\x90p\xE7\xC4\xC1>\x8Di\xD6\x0F\x9A\xDE\xE5\xAF\xB2&\xD1\xCD\xBC8\xB9\x03\xEDm\xB4\x85b\x82\x1FoN\x19\xA7+F\xBC\xB9\xAD\xE3\xDA\x1F\xC5\xB700\xA4\x18\x10d\x16\x1Fb\xF6Z\x9E\xAE\xDA[\xF6\xE3_-]\x91\x99\xFA\xE4v\x8D\xC5\xADo4]\x969\xAFY\xF6\xE9{\x15\x01\xAA\xF1\xC8\x19!W\xE4\x82g\x7F\x8C\x96\xB0\xE5\x90\xA1\xAD\x8E\xE8uG\xF5\xA6\xFD\xCE\xF2-\x8D\xC9v\fp\rsnaU\x83B\xFA{H\xAC\x04\xCB\xFD\xFE\x9E\xC7\x95\xF3#&\xB22\xC52\xBD\xB8\xD2\x17Yb\x18d\xF8*\x13'\x1Cc\xC5\xCA\x86\x12o +\xF2\xDB\xB3O\xB4\xF4nC\a\xBDd\xF4+\x19|w\xC2`R\xEB\x1E&e\xF88Q\xF3>\x91\xC6\xA7ZY\xC5\x9FD\xEC\a\x11\xB0\x03\x9F\x19",
    :aes_iv => "\x1A\x86\xA8\xA6\xEA\xFDb\x9E\xC4\x02\xA9'\xFC\xA6I7\xC1\x10\xA0\x8D\xE4WC\xEDC&\xF2\x10\xB3B\xBD\x14\xF9\x90\xA6\xBB\xDAD\xD5\xE8$+b#\b\x9F|\x80\xB9\x81\x7F\x89\x7F\t\xE3\b\xAD\n]\x8F\xA2\xE4\x13w\xD1\xDB\xB9\xC8\xD1M&\x9C\xD9U\x9C\x7F\xAB\xA3\x95~\x85\x9B\xD6\x8B\x82\x7F\b\x9E\x94\xB7\xEDJ\x8B\x0F0\x90\xD0\xCEU\x85\xD2gf\xB4\xF9;\x83\xB3\xC2Hs\xFB\x1F\e\xDE\xD7\x8EH\xC37\xCE\xFBw\x01\x9C\xE1\xFD\x83\xD6\xA0}V\xE9\\;\xE8U\xBAI\x1Foi\x9D\xF6O!\xDE\xA0?h\xE3\x99\xF7-\xAEs\xF7\xCE\x88d\x17[q\xBFSx\xA7\x8Ag-\x8A\x13V\xBA\x18\x117\xC6\xFAz_\v\x15D\tD8\x8F\xBE7\xB2(28\xB3\x12\xAC\xA2i<u\xE3\x14~}<EMYib\xF5N\xBC\x82I\xB9\xF2\xDD\xFEU\xE0\x10\x19E\xCD\xAAfbn&\xB9\xA9\xDB9\xB2\x0E\xFA+!i\xB6\xE2z!\xF0\x8B\xE8j\x96#\x18\xB1\xE9\xE5\x19"})     
  
#  Load the contents from the folder contents
#  Persistence.setup(:default, {:adapter=>'memory'})
#  ResourceLoader.instance.load_files(ContentManagerSystem::Content, File.join(File.dirname(File.expand_path(__FILE__)),'data/persistence/content'))     
#  ResourceLoader.instance.load_files(Users::Profile, File.join(File.dirname(File.expand_path(__FILE__)),'data/persistence/user')) 
  
  # --- OTHER ENVIRONMENT CONFIGURATIONS ----
  
  # Postal service
  PostalService.account(:default, {:via => :smtp, :via_options => {:address => 'smtp.gmail.com', :port => '587', :user_name => 'yurak.sisa.customers' , :password => 'chiriyuyo', :enable_starttls_auto => true, :domain => 'localhost@localdomain', :authentication => :plain }})
  PostalService.setup( :enable_tls => true )
