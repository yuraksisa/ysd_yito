require 'fileutils'
module Yito
  class YitoApp
  	extend Thor::Actions

  	def self.create(app_name)
      
      puts "Creating the application ...."

      # Copy the templates to the current directory
      
      ['config.ru', 'Procfile', 'Gemfile', 'my_web.rb', 'Rakefile', 'config', 'themes', 'views'].each do |file_name|
        
        source= File.expand_path(File.join(__FILE__, '..', '..', 'templates', 'yito', file_name))
        destination= File.join(Dir.pwd, file_name)

        if File.directory?(source)
          FileUtils.copy_entry(source, destination)
        else
          FileUtils.copy_file(source, destination)
        end

      end

      puts "Application created"

    end
  end
end