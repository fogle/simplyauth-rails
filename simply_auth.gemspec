$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simply_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simply_auth"
  s.version     = SimplyAuth::VERSION
  s.authors     = ["Ryan Fogle"]
  s.email       = ["ryan@simplyauth.com"]
  s.homepage    = "https://www.simplyauth.com"
  s.summary     = "The simple managed user service"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"
  s.add_dependency "rest-client"
  s.add_dependency 'http_signatures'
end
