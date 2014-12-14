require File.join([File.dirname(__FILE__),'lib','git-projects','version.rb'])
Gem::Specification.new do |s|
  s.name = 'git-projects'
  s.version = GitProjects::VERSION
  s.author = 'Katherine Pe'
  s.email = 'k@kat.pe'
  s.homepage = 'https://github.com/katgironpe/git-projects'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Easily manage Git projects'
 s.files = [
    'lib/git-projects.rb',
    'lib/helpers/git-project.rb',
    'lib/helpers/projects.rb',
    'lib/git-projects/version.rb'
   ]
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.license     = 'MIT'
  s.files = Dir['lib/**/*.rb']
  s.executables << 'git-projects'
  s.add_dependency('colorize')
  s.add_dependency('git', '~> 1.2')
  s.add_development_dependency('aruba', '~> 0.6')
  s.add_development_dependency('cucumber')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-core')
  s.add_runtime_dependency('gli','~> 2.0')
end
