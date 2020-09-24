Gem::Specification.new do |s|
  s.name        = 'judge0'
  s.version     = '0.0.5'
  s.date        = '2020-01-20'
  s.summary     = 'ruby interface for judge0 api.'
  s.description = 'ruby interface for judge0 api.'
  s.authors     = ['Breno Nunes']
  s.email       = 'breno.nunesgalvao@protonmail.ch'
  s.files       = %w[LICENSE README.md judge0.gemspec] + Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/TopRoupi/judge0-gem'
  s.license     = 'MIT'

  s.add_runtime_dependency 'faraday', '>= 1.0.0'
end
