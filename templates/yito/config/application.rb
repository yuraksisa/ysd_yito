    BASE_PATH = Dir.pwd

    # Configure the theme system
    Themes::ThemeManager.setup(File.join(File.expand_path(BASE_PATH),'themes'))
    Themes::ThemeManager.instance.select_theme(:default) 

    # Configure the views and public directories
    set :views, [File.join(File.expand_path(BASE_PATH), 'views')]

    # Configure the language
    set :default_locale, 'es'
    set :translations, File.join(File.expand_path(BASE_PATH), 'i18n')
    ::R18n::I18n.default = 'es'
    ::R18n.default_places = Proc.new { settings.translations }
                 
    # Authentication and authorization module configuration
    set :success_path, '/'
    set :failure_path, '/login'
    set :logout_path, '/'
    set :login_page, :login            
    
    # CMS module configuration
    set :cms_author_url, "/profile/%1s"
 
    # PROFILE module configuration
    set :profile_members_page_size, 12
        
    # Templating
    TemplateService::TemplateBuilder.setup(:root => File.dirname(BASE_PATH))         