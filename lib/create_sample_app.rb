require 'fileutils'
module Yito
  class SampleApp

    def self.create(app_name)

      # Copy the templates to the current directory

      ['config.ru', 'Gemfile', 'yito_web.rb'].each do |file_name|
        
        source= File.expand_path(File.join(__FILE__, '..', '..', 'templates', 'sample', file_name))
        destination= File.join(Dir.pwd, file_name)

        FileUtils.copy_file(source, destination)

      end

    end

  end
end