#require 'create_sample_app'
#require 'create_yito_app'
#require 'fileutils'
require 'fileutils'

module Yito
  class App < Thor

    desc "sample APP_NAME", "Create a new sample application to deploy on Heroku"
    def sample(name)
      #Yito::SampleApp.create(name)

      # Copy the templates to the current directory

      ['config.ru', 'Gemfile', 'yito_web.rb'].each do |file_name|
        
        source= File.expand_path(File.join(__FILE__, '..', '..', 'templates', 'sample', file_name))
        destination= File.join(Dir.pwd, file_name)

        FileUtils.copy_file(source, destination)

      end

    end

    desc "create APP_NAME", "Create a new yito application"   
    def create(name)
      #Yito::YitoApp.create(name)

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

    end
  
    desc "help", "List the options"
    def help
      puts "Command line utility to create apps"
      puts "Usage:"
      puts "yito sample APP_NAME - Create a sample Sinatra application ready to be deployed on heroku"
      puts "yito create APP_NAME - Create a Yito application"
    end
 
    default_task :help

  end
end