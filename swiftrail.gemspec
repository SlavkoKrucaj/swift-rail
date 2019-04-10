lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swiftrail/version'

Gem::Specification.new do |spec|
  spec.name          = 'swiftrail'
  spec.version       = Swiftrail::VERSION
  spec.authors       = ['Slavko Krucaj']
  spec.email         = ['slavko.krucaj@gmail.com']

  spec.summary       = 'Library that manages reporting of swift test results to test rail.'
  spec.homepage      = 'https://www.github.com/SlavkoKrucaj/swiftrail'
  spec.license       = 'MIT'

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.10'
  spec.add_dependency 'thor', '~> 0.20'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
