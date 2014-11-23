module Sinatra
  module YSD
    #
    # It's a Sinatra middleware who manages the web site.
    #
    #  - Shows the home page /
    #  - Shows the dashboard page /dashboard (home page for registered users)
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
        
          p "Site public home page"

          front_page = SystemConfiguration::Variable.get_value('site.anonymous_front_page', nil) 
                       
          if front_page
            status, header, body = call! env.merge("PATH_INFO" => front_page) 
          else
            load_page :frontpage
          end
          
        end        

        #
        # Site dashboard
        #
        app.get '/dashboard/?', :allowed_usergroups => ['user', 'staff'] do
                
           p "Site dashboard"
                
           dashboard_page = SystemConfiguration::Variable.get_value('site.front_page', nil)
           
           if dashboard_page 
             status, header, body = call! env.merge("PATH_INFO" => dashboard_page) 
           else
             load_page :dashboard_frontpage
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