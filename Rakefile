require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'


spec = eval(File.read('git-projects.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

CUKE_RESULTS = 'results.html'

CLEAN << CUKE_RESULTS

desc 'Run features'
Cucumber::Rake::Task.new(:features) do |t|
  opts = "features --format html -o #{CUKE_RESULTS} --format progress -x"
  opts += " --tags #{ENV['TAGS']}" if ENV['TAGS']
  t.cucumber_opts =  opts
  t.fork = false
end

desc 'Run features tagged as work-in-progress (@wip)'
Cucumber::Rake::Task.new('features:wip') do |t|
  tag_opts = ' --tags ~@pending'
  tag_opts = ' --tags @wip'
  t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} --format pretty -x -s#{tag_opts}"
  t.fork = false
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'nested']
end

task cucummber: :features
task 'cucumber:wip' => 'features:wip'
task wip: 'features:wip'
task default: [:spec, :features]
