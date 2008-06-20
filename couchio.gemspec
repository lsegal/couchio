SPEC = Gem::Specification.new do |s|
  s.name          = "couchio"
  s.version       = "0.1.0"
  s.date          = "2008-05-20"
  s.author        = "Loren Segal"
  s.email         = "lsegal@soen.ca"
  s.homepage      = "http://couchio.soen.ca"
  s.platform      = Gem::Platform::RUBY
  s.summary       = "Virtual filesystem support for a CouchDB database." 
  s.files         = Dir.glob("{lib}/**/*") + ['LICENSE', 'README.markdown', 'Rakefile']
  s.require_paths = ['lib']
  s.has_rdoc      = false
  #s.rubyforge_project = 'couchio'
  s.add_dependency 'json'
end