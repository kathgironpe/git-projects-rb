require_relative 'project'
require 'git'
require 'yaml'

class GitProject

  attr :project

  def initialize(config)
    @project = Project.new(config)
  end

  class << self
    # Create YAML file
    def create_yaml_file(config_file, projects)
      File.open(config_file, "w") do |f|
        f.write projects.to_yaml.gsub(/- /,'').gsub(/    /,'  ').gsub(/---/,'')
      end
    end

    # Create a hash for remotes
    def add_remotes_to_hash(g, p, dir)
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
    def create_config(dir)
      dir = dir.is_a?(Array) ? dir.first : dir
      config_file = "#{dir}/git-projects.yml"
      unless File.exists?(config_file)
        projects = []
        Dir.entries(dir)[2..-1].each do |project|
          g = Git.open("#{dir}/#{project}")
          p = {}
          p[project]  = add_remotes_to_hash(g, p, dir)
          projects << p
          create_yaml_file(config_file, projects)
        end
      else
        raise "The config file, #{config_file} exists"
      end
    end

    def set_root_path(path)
      @project.set_root_path(path)
    end

    # Create dir unless it exists
    def create_directory(path)
      unless File.directory?(path)
        `mkdir -p #{path}`
        printf("Creating directory: %s\n", path)
      end
    end

    # Create root_dir
    def create_root_dir(path)
      GitProject.create_directory(path) unless File.directory?(path)
    end

    # Clone unless dir exists
    def clone(url, name, path)
      r = "#{path}/#{name}"
      if Git.open(r)
        p "Already cloned #{url}"
      else
        Git.clone(url, name, path: path) || Git.init(r)
        g = Git.open(r)
        p "Cloning #{url} as #{name} into #{path}"
      end
      g
    end

    # Add remote
    def add_remote(g, v)
      g.add_remote('all', v['origin'])
      v.each do |name, remote|
        unless ['root_dir', 'origin', 'all'].include?(name)
          g.add_remote(name, remote) unless g.remotes.map(&:name).include?(name)

          # add to all remote
          # useful when you want to do git push all --all
          `git remote set-url --add all #{remote}`
        end
      end
    end

    def fetch(g, url)
      g.remotes.each do |r|
        unless r.name=='all'
          r.fetch
          p "Fetching updates from #{r.name} : #{r.url}"
        end
      end
    end
  end

  # 1. Clone all repositories based on the origin key
  # 2. Add all other remotes unless it is origin
  def clone_all
    @project.all.each do |k,v|
      begin
        p "root_dir isn't defined for #{k}" unless v['root_dir']
        p "The dir #{v['root_dir']} does not exist" unless File.directory?(v['root_dir'])
        GitProject.create_root_dir(v['root_dir'])
        g =  GitProject.clone(v.values[0], k, v['root_dir'])
        GitProject.add_remote(g,v) if g
      rescue => e
        g = Git.init("#{v['root_dir']}/#{k}")
        if g
          GitProject.add_remote(g,v)
          GitProject.fetch(g, v)
        end
        p "Please check paths and permissions for #{k}. Error: #{e}"
        p "Failed to clone #{v.values[0]}. Initialized & fetch update from remotes instead."
      end
    end
  end

  # Fetch all updates for remotes for all projects
  def fetch_all
    p "Found #{@project.all.size} projects"
    @project.all.each do |k,v|
      p "Fetching changes for #{k}"
      GitProject.create_root_dir(v['root_dir'])
      working_dir = "#{v['root_dir']}/#{k}"
      g = Git.open(working_dir) || Git.init(working_dir)
      GitProject.fetch(g, v)
      GitProject.add_remote(g,v)
    end
    return true
  end

end
