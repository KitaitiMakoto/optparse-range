Gem::Specification.new do |gem|
  gem.name          = "optparse-range"
  gem.version       = '0.0.1'
  gem.authors       = ["KITAITI Makoto"]
  gem.email         = ["KitaitiMakoto@gmail.com"]
  gem.description   = %q{This RubyGem allows standard bundled `OptionParser` to accept option arguments as `Range` object.}
  gem.summary       = %q{Range command line arguments handling}
  gem.homepage      = "https://github.com/KitaitiMakoto/optparse-range"
  gem.licenses      = ['Ruby', 'BSDL']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
end
