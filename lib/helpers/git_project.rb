require_relative 'git_project_config'
require_relative 'git_project_remote'
require_relative 'project'
require 'git'
require 'yaml'
require 'colorize'

# GitProject contains helpers for Git commands
class GitProject
  attr_reader :project

  include GitProjectConfig
  include GitProjectRemote

  def initialize(config)
    @project = Project.new(config)
  end

  def init
    @project.all.each do |k, v|
      begin
        create_project_and_remotes(k, v)
      rescue => e
        initialize_and_add_remotes(k, v)
        puts "Please check paths and permissions for #{k}. Error: #{e}".red
        puts "Failed to clone #{v.values[0]}. Initialized &
              fetched updates from remotes instead.".yellow
      end
    end
  end

  def initialize_and_add_remotes(k, v)
    g = Git.init("#{v['root_dir']}/#{k}")
    return nil unless g
    GitProject.add_remote(g, v)
    GitProject.fetch(g)
  end

  def projects
    @project.all
  end

  # Add a new remote
  def new_remote(project, name, url)
    @project.new_remote(project, name, url)
  end

  # Change group
  def new_group(project, name)
    @project.new_group(project, name)
  end

  # Add missing remotes
  def add_remotes
    @project.all.each do |k, v|
      working_dir = "#{v['root_dir']}/#{k}"
      g = Git.open(working_dir) || Git.init(working_dir)
      GitProject.add_remote(g, v)
      puts "Checking new remotes for #{k}".green
    end
  end

  # 1. Clone all repositories based on the origin key
  # 2. Add all other remotes unless it is origin
  def create_project_and_remotes(k, v)
    puts "root_dir isn't defined for #{k}" unless v['root_dir']
    unless File.directory?(v['root_dir'])
      puts "The dir #{v['root_dir']} does not exist"
    end
    GitProject.create_root_dir(v['root_dir'])
    g =  GitProject.clone(v.values[0], k, v['root_dir'])
    GitProject.add_remote(g, v) if g
  end

  # By default, fetch from all
  def fetch_all(group = nil)
    @project.all(group).each do |k, v|
      puts "Fetching changes for #{k}".green
      GitProject.create_root_dir(v['root_dir'])
      working_dir = "#{v['root_dir']}/#{k}"
      g = Git.open(working_dir) || Git.init(working_dir)
      GitProject.fetch(g)
    end
  end
end
