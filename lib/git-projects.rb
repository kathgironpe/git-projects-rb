#!/usr/bin/env ruby
require 'gli'
require 'json'
require_relative 'helpers/project'
require_relative 'helpers/git_project'

include GLI::App

program_desc 'Easily manage Git projects'

pre do |global_options,command,options,args|
  if ENV['GIT_PROJECTS']
    p ENV['GIT_PROJECTS']
  else
    raise "Please add the path your git projects config. \n export GIT_PROJECTS=/path/to/git_projects.yml:$GIT_PROJECTS"
  end
end

desc 'Create a config'
skips_pre
command :config do |c|
  c.action do |global_options,options,args|
    config_path = "#{args.first}/git-projects.yml"
    GitProject.create_config(args)
    if File.open(config_path)
      p "successfully created git-projects.yml"
    end
  end
end

desc 'Clone all projects'
command :clone do |c|
  c.action do
    if GitProject.new(ENV['GIT_PROJECTS']).clone_all
      p 'successfully cloned repositories'
    end
  end
end

desc 'Fetch changed from all remotes'
command :fetch do |c|
  c.action do
    if GitProject.new(ENV['GIT_PROJECTS']).fetch_all
      p 'successfully fetched changes'
    end
  end
end

exit run(ARGV)
