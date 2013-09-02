module Sinatra
  module YSD
    #
    # It's a Sinatra middleware who manages the web site.
    #
    #  - Shows the home page /
    #  - Helpers to render pages and to load static resources
    #
    #
    module Site
   
      def self.registered(app)
                    
        app.enable :logging
     
        #
        # Site home page
        #
        app.get '/?' do
        
          front_page = if authenticated? and not user.belongs_to?('anonymous')
                         if sfp=SystemConfiguration::Variable.get('site.front_page') 
                           sfp.value
                         end
                       else 
                         if sfp=SystemConfiguration::Variable.get('site.anonymous_front_page') 
                           sfp.value
                         end
                       end
          
          if front_page
            status, header, body = call! env.merge("PATH_INFO" => front_page) 
          else
            load_page :frontpage
          end
          
        end        
                
        #
        # Serves the main static content (css, img ,js) from the theme
        #
        app.get "/*" do
 
          if Plugins::Plugin.plugin_invoke_all(:ignore_static_resources, {:app => self}).include?(request.path)
            pass
          end

          serve_static_resource(request.path_info, File.join(File.dirname(__FILE__), '..', '..', 'static') )
            
        end        
             
                                
      end
    
    end # Site
  end # YSD
end # Sinatra