# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "tty-fireworks"
  gem.version       = "0.0.1"
  gem.authors       = ["Mark Lorenz"]
  gem.email         = ["markjlorenz@dapplebeforedawn.com"]
  gem.description   = %q{Fireworks in your terminal}
  gem.summary       = %q{For those extra special commits}
  gem.homepage      = "https://github.com/dapplebeforedawn/ruby-fireworks"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
