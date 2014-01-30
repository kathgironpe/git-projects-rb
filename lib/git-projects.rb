#!/usr/bin/env ruby
require 'gli'
require 'json'
require 'colorize'
require_relative 'helpers/project'
require_relative 'helpers/git_project'

include GLI::App

program_desc 'Easily manage Git projects'

desc 'Create a config'
command :config do |c|
  c.action do |global_options,options,args|
    config_path = "#{args[0]}/git-projects.yml"
    group = args[1] || nil
    GitProject.create_config(args[0], group)
    if File.open(config_path)
      puts "Successfully created git-projects.yml".green
    end
  end
end

desc 'Clone or initialize all projects'
command :init do |c|
  c.action do
    GitProject.check_config # the pre feature of GLI has a bug. investigate later.
    GitProject.new(ENV['GIT_PROJECTS']).init
  end
end

desc 'Add missing remotes'
command :'add-remotes' do |c|
  c.action do
    GitProject.check_config
    GitProject.new(ENV['GIT_PROJECTS']).add_remotes
  end
end

desc 'Fetch changes from all remotes'
command :fetch do |c|
  c.action do |global_options,options,args|
    GitProject.check_config
    if GitProject.new(ENV['GIT_PROJECTS']).fetch_all(args[0])
      puts "Successfully fetched changes".green
    end
  end
end

exit run(ARGV)
