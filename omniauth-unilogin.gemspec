# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-unilogin/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-unilogin"
  s.version     = Omniauth::Unilogin::VERSION
  s.authors     = ["Bo Stendal Sørensen"]
  s.email       = ["bo@stendal-sorensen.net"]
  s.homepage    = "https://github.com/jihao/omniauth-unilogin"
  s.summary     = %q{omniauth strategy for unilogin by unic.dk }
  s.description = %q{omniauth strategy for unilogin by unic.dk. Authenticate using the uni-c API.}

  s.rubyforge_project = "omniauth-unilogin"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'omniauth', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 2.7'
  # s.add_runtime_dependency "rest-client"
end