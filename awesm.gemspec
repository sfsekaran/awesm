$:.push File.expand_path("../lib", __FILE__)
require "awesm/version"

Gem::Specification.new do |s|
  s.name        = "awesm"
  s.version     = Awesm::VERSION
  s.authors     = ["Sathya Sekaran", "Michael Durnhofer", "Cody Johnston"]
  s.email       = ["sfsekaran@gmail.com", "mdurnhofer@gmail.com", "cody@codegobl.in"]
  s.homepage    = "http://github.com/sfsekaran/awesm"
  s.summary     = %q{Totally awe.sm!}
  s.description = %q{The 'awesm' gem is an interface for awe.sm (http://totally.awe.sm), a social link analytics tracking service.}

  s.rubyforge_project = "awesm"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here;
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "= 2.7.0"
  s.add_development_dependency "webmock", "= 1.7.8"
  s.add_development_dependency "json"
  s.add_development_dependency "hashie"
  s.add_development_dependency "ruby-debug"

  s.add_runtime_dependency "httparty", "= 0.8.1"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "hashie"
end
