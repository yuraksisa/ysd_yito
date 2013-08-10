Gem::Specification.new do |s|
  s.name    = "<%=plugin_name%>"
  s.version = "<%=plugin_version%>"
  s.authors = ["<%=plugin_authors%>"]
  s.date    = "<%=plugin_date%>"
  s.email   = ["<%=plugin_email%>"]
  s.files   = Dir['lib/**/*.rb']
  s.description = "<%=plugin_description%>"
  s.summary = "<%=plugin_summary%>"
  s.homepage = "<%=plugin_homepage%>"    


  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  #s.add_development_dependency "dm-sqlite-adapter" # Model testing using sqlite

end