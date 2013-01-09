require 'thor'
require 'create_sample_app'
require 'create_yito_app'

module Yito
  class App < Thor
  
    desc "sample APP_NAME", "Create a new sample application to deploy on Heroku"
    def sample(name)
      Yito::SampleApp.create(name)
    end

    desc "create APP_NAME", "Create a new yito application"   
    def create(name)
      Yito::YitoApp.create(name)
    end
  
    desc "help", "List the options"
    def help
      puts "Command line utility to create apps"
      puts "Usage:"
      puts "yito sample APP_NAME - Create a sample Sinatra application ready to be deployed on heroku"
      puts "yito create APP_NAME - Create a Yito application"
    end
 
  end
end