require_relative 'project'
require 'git'
require 'yaml'
require 'colorize'

# GitProject contains helpers for Git commands
class GitProject
  attr_reader :project

  def initialize(config)
    @project = Project.new(config)
  end

  class << self
    # Create YAML file
    def create_yaml_file(config_file, projects)
      File.open(config_file, 'w') do |f|
        f.write projects.to_yaml.gsub(/- /, '').gsub(/    /, '  ').gsub(/---/, '')
      end
    end

    # Create a hash for remotes
    def add_remotes_to_hash(g, dir)
      remotes_h = {}
      r = {}
      remotes_h.tap do |remotes|
        g.remotes.each do |remote|
          r[remote.name] = remote.url
        end
        r['all'] = true
        r['root_dir'] = dir
        remotes.merge!(r)
      end
    end

    # Create a configuration file based on a root path
    def create_config(dir, group = nil)
      dir = dir.is_a?(Array) ? dir.first : dir
      config_file = File.join(dir, 'git-projects.yml')
      group ||= dir.split(File::SEPARATOR).last if dir

      fail "The config file, #{config_file} exists" if File.exist?(config_file)

      projects = []
      Dir.entries(dir)[2..-1].each do |project|
        g = Git.open(File.join(dir, project))
        p = {}
        p[project] = add_remotes_to_hash(g, dir)
        p[project]['group'] = group
        projects << p
        create_yaml_file(config_file, projects)
      end
      puts "You can later fetch changes through:
            \ngit-projects fetch #{group}".green
    end

    def create_root_path(path)
      @project.create_root_path(path)
    end

    # Create dir unless it exists
    def create_directory(path)
      `mkdir -p #{path}` unless File.directory?(path)
      puts 'Creating directory: '.green + "#{path}".blue
    end

    # Create root_dir
    def create_root_dir(path)
      GitProject.create_directory(path) unless File.directory?(path)
    end

    # Check for the config
    def check_config
      if ENV['GIT_PROJECTS']
        puts "Checking repositories. If things go wrong,
              update #{ENV['GIT_PROJECTS']}".green
      else
        fail "Please add the path your git projects config. \n
              export GIT_PROJECTS=/path/to/git_projects.yml"
      end
    end

    # Clone unless dir exists
    def clone(url, name, path)
      r = "#{path}/#{name}"
      if Git.open(r)
        puts 'Already cloned '.yellow + "#{url}".blue
      else
        Git.clone(url, name, path: path) || Git.init(r)
        g = Git.open(r)
        puts "Cloning #{url} as #{name} into #{path}".green
      end
      g
    end

    # Add remote
    def add_remote(g, v)
      unless g.remotes.map(&:name).include?('all')
        g.add_remote('all', v['origin'])
      end
      v.each do |name, remote|
        next if  %w(root_dir all group).include?(name) ||
          g.remotes.map(&:name).include?(name)
        if g.add_remote(name, remote)
          # add to all remote
          # useful when you want to do git push all --all
          `git remote set-url --add all #{remote}`
          puts "Added remote #{name}".green
        end
      end
    end

    def fetch(g)
      g.remotes.each do |r|
        next if %w(root_dir all group).include?(r.name)
        r.fetch
        puts "Fetching updates from #{r.name}: #{r.url}".green
      end
    end
  end

  # 1. Clone all repositories based on the origin key
  # 2. Add all other remotes unless it is origin
  def create_project_and_remotes(k, v)
    unless v['root_dir']
      puts "root_dir isn't defined for #{k}"
    end
    unless File.directory?(v['root_dir'])
      puts "The dir #{v['root_dir']} does not exist"
    end
    GitProject.create_root_dir(v['root_dir'])
    g =  GitProject.clone(v.values[0], k, v['root_dir'])
    GitProject.add_remote(g, v) if g
  end

  def initialize_and_add_remotes(k, v)
    g = Git.init("#{v['root_dir']}/#{k}")
    return nil unless g
    GitProject.add_remote(g, v)
    GitProject.fetch(g)
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

  # Fetch all updates
  # Group is optional
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
