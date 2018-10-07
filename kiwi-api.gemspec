lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'kiwi/api/version'

Gem::Specification.new do |s|
  s.name = 'kiwi-api'
  s.version = Kiwi::API::VERSION
  s.authors = ['Mikhail Slyusarev']
  s.email = ['slyusarevmikhail@gmail.com']
  s.summary = 'Ruby bindings for the kiwi.com API'
  s.homepage = 'https://gitlab.com/mikhailvs/kiwi-ruby'
  s.files = ['lib/**/*.rb']
  s.require_paths = ['lib']

  s.add_runtime_dependency 'faraday'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
