Gem::Specification.new do |s|

  s.name    = "ysd_yito"
  s.version = "0.1.49"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-12-11"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb', 'templates/**/*', 'bin/**/*'] 
  s.description = "Base project to create web applications"
  s.summary = "Base project to create web applications"
  s.executables << 'yito'

  s.add_runtime_dependency "sinatra"         
  s.add_runtime_dependency "sinatra-r18n"
  s.add_runtime_dependency "rack" 
  s.add_runtime_dependency "json"
  
  s.add_runtime_dependency "tilt"
  s.add_runtime_dependency "thor"

  s.add_runtime_dependency "ysd_yito_core", ">= 0.1"
  s.add_runtime_dependency "ysd_yito_js", ">= 0.1"  
  s.add_runtime_dependency "ysd_md_yito"

  s.add_runtime_dependency "ysd_core_plugins",">= 0.2.0"
  s.add_runtime_dependency "ysd_core_themes",">= 0.2.0"
  s.add_runtime_dependency "ysd-persistence",">= 0.2.0"  

end