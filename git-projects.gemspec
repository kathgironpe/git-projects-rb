require File.join([File.dirname(__FILE__),'lib','git-projects','version.rb'])
Gem::Specification.new do |s|
  s.name = 'git-projects'
  s.version = GitProjects::VERSION
  s.author = 'Katherine Pe'
  s.email = 'k@kat.pe'
  s.homepage = 'https://github.com/katgironpe/git-projects'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Easily manage Git projects'
  s.files = `git ls-files`.split("
                                 ")
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.license     = 'MIT'
  s.files = Dir['lib/**/*.rb']
  s.executables << 'git-projects'
  s.add_dependency('git', '1.2.6')
  s.add_development_dependency('rake')
  s.add_development_dependency('aruba')
  s.add_runtime_dependency('gli','2.9.0')
end
