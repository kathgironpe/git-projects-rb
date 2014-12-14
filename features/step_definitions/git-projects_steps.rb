require_relative '../../spec/support/test_repos'
require_relative '../../lib/helpers/git_project'

include TestRepos

When /^I fetch changes from all remotes$/ do
  step %(I run `git-projects fetch`)
end

When /^I change the group for "(.*?)" to "(.*?)"$/ do |project, group|
  change_group(project, group)
end

Then /^I fetch changes from all remotes for "(.*?)" projects$/ do |name|
  step %(I run `git-projects fetch #{name}`)
end

When /^I check repositories$/ do
  step %(I run `git-projects init`)
end

When /^I get help for "([^"]*)"$/ do |app_name|
  step %(I run `git-projects help`)
end

When /^I add "(.*?)" remote for "(.*?)"$/ do |remote, name|
  add_remote(name, remote)
end

When /^the git projects config path does not exist$/ do
  ENV['GIT_PROJECTS'] = nil
end

When /^I add remotes$/ do
  step %(I run `git-projects add-remotes`)
end

When /^I create a config for repositories$/ do
  project_path = 'tmp/repos'
  path = git_projects_path(project_path)
  config_path = "#{path}/git-projects.yml"
  clean_projects_path(project_path)
  create_git_projects(project_path)
  `rm #{config_path}` if File.exists?(config_path)
  GitProject.create_config(path)
  ENV['GIT_PROJECTS'] = config_path
end

When /^I create a config for repositories with group "(.*?)"$/ do |name|
  project_path = 'tmp/repos'
  path = git_projects_path(project_path)
  config_path = "#{path}/git-projects.yml"
  clean_projects_path(project_path)
  create_git_projects(project_path)
  `rm #{config_path}` if File.exists?(config_path)
  GitProject.create_config(path, name)
  ENV['GIT_PROJECTS'] = config_path
end

Then /^the output should not match \/([^\/]*)\/$/ do |expected|
  assert_not_matching_output(expected, all_output)
end

Then /^the output should not contain \/([^\/]*)\/$/ do |unexpected|
  assert_no_partial_output(unexpected, all_output)
end

Then /^the directory ([^"]*)" should exist$/ do |dir|
  File.directory?(dir)
end
