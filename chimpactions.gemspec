# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "chimpactions/version"

Gem::Specification.new do |s|
  s.name        = "chimpactions"
  s.version     = Chimpactions::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peter Bonnell"]
  s.email       = ["gems@circuitllc.com"]
  s.homepage    = ""
  s.summary     = %q{chimpactions provides a quick way to move subscribers from one MailChimp list to another.}
  s.description = %q{chimpactions  }

  s.rubyforge_project = "chimpactions"

  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.textile","chimpactions.gemspec"]
  s.test_files    = [] #`git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('gibbon', '>= 0.1.5')

  s.post_install_message = %[
chimpactions has been installed.
]
end
