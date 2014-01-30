require 'yaml'
require 'colorize'

class Project

  attr :projects

  def initialize(config)
    @projects = YAML.load_file(config)
  end

  def all(group=nil)
    group ? @projects.select { |k, v| v['group'].include?(group) } : @projects
  end

  def first
    all.first
  end

  def set_root_path(path)
    @projects.tap do |project|
      project.each do |k,v|
        v['root_dir'] = path
      end
    end
  end

  def new_remote(remote, name, url)
    @projects.tap do |project|
      project[remote][name] = url
    end
  end

  def new_group(remote, name)
    @projects.tap do |project|
      project[remote]['group'] = name
    end
  end
end
