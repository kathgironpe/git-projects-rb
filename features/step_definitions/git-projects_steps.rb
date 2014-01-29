require_relative '../../test/test_repos'
require_relative '../../lib/helpers/git_project'

include TestRepos

When /^the git projects config path is defined$/ do
  project_path = '/tmp/repos'
  path = git_projects_path(project_path)
  config_path = "#{path}/git-projects.yml"
  clean_projects_path(project_path)
  create_git_projects(project_path)
  GitProject.create_config(path)
  ENV['GIT_PROJECTS'] = config_path
end

When /^I fetch changes from all remotes$/ do
  step %(I run `git-projects fetch`)
end

When /^I clone repositories$/ do
  step %(I run `git-projects clone`)
end

When /^I get help for "([^"]*)"$/ do |app_name|
  step %(I run `git-projects help`)
end

When /^the git projects config path does not exist$/ do
  ENV['GIT_PROJECTS'] = nil
end

When /^I create a config for repositories$/ do
  project_path = '/tmp/repos'
  path = git_projects_path(project_path)
  config_path = "#{path}/git-projects.yml"
  clean_projects_path(project_path)
  create_git_projects(project_path)
  GitProject.create_config(path)
  `rm #{config_path}`
  step %(I run `git-projects config #{path}`)
end

Then /^the output should contain ([^"]*)"$/ do |output|
  assert_matching_output(output)
end

Then /^the directory ([^"]*)" should exist$/ do |dir|
  File.directory?(dir)
end
