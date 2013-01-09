# ===============================================
# config.ru for running the RackApplication
# -----------------------------------------------
# It can be run using $rackup
# It's ready to be deployed in Heroku
# ===============================================
require 'rubygems'

require 'bundler/setup' 
require 'bundler'
Bundler.require

# The application
require './yito_web.rb'
run Sinatra::Yito