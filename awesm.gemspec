$:.push File.expand_path("../lib", __FILE__)
require "awesm/version"

Gem::Specification.new do |s|
  s.name        = "awesm"
  s.version     = Awesm::VERSION
  s.authors     = ["Sathya Sekaran", "Michael Durnhofer"]
  s.email       = ["sfsekaran@gmail.com", "mdurnhofer@gmail.com"]
  s.homepage    = "http://github.com/sfsekaran/awesm"
  s.summary     = %q{Totally awe.sm!}
  s.description = %q{The 'awesm' gem is an interface for awe.sm (http://totally.awe.sm), a social link analytics tracking service.}

  s.rubyforge_project = "awesm"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here;
  s.add_development_dependency "rspec"
  s.add_development_dependency "webmock"
  s.add_development_dependency "httparty"
  s.add_development_dependency "json"

  s.add_runtime_dependency "httparty"
  s.add_runtime_dependency "json"
end
