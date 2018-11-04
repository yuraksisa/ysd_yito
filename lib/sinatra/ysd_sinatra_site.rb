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

        # Add the local folders to the views and translations     
        app.settings.views = Array(app.settings.views).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'views')))
        app.settings.translations = Array(app.settings.translations).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'i18n')))       

        app.enable :logging
     
        #
        # Site home page
        #
        app.get '/?' do
        
          front_page = SystemConfiguration::Variable.get_value('site.anonymous_front_page', nil) 

          if front_page and (not front_page.empty?) and (not front_page == '/')
            status, header, body = call! env.merge("PATH_INFO" => front_page) 
          else
            load_page :frontpage
          end
          
        end        

        #
        # Site dashboard
        #
        app.get '/dashboard/?', :allowed_usergroups => ['user', 'editor', 'staff', 'webmaster', 'booking_manager', 'booking_operator'] do
                
           allowed_groups = ['editor', 'webmaster', 'booking_manager', 'booking_operator', 'staff', 'user']
           if user.belongs_to?(allowed_groups)
             dashboard_page = nil
             allowed_groups.each do |item|
               next if !user.belongs_to?(item)
               p "item : #{item}"
               dashboard_page = SystemConfiguration::Variable.get_value("site.#{item}_front_page")
               dashboard_page = nil if !dashboard_page.nil? && dashboard_page.empty?
               break unless dashboard_page.nil?
             end
             dashboard_page = SystemConfiguration::Variable.get_value('site.front_page', nil) if dashboard_page.nil?
           else
             dashboard_page = SystemConfiguration::Variable.get_value('site.user_front_page', nil)
           end
                      
           if dashboard_page 
             p "DASHBOARD: #{dashboard_page}"
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