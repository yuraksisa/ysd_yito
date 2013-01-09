require 'sinatra/base'
module Sinatra
  #
  # The application
  #
  class Yito < Sinatra::Base
   
    set :public_folder, './'

    get '/' do 
      "Hello world!"
    end

  end
end