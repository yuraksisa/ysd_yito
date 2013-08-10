require 'ysd-plugins' unless defined?Plugins::Plugin

Plugins::SinatraAppPlugin.register '<%=name%>' do

   name=        '<%=name%>'
   author=      '<%=author%>'
   description= '<%=description%>'
   version=     '0.1'

end