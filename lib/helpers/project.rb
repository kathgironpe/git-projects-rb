require 'yaml'

class Project

  attr :projects

  def initialize(config)
    @projects = YAML.load_file(config)
  end

  def all
    @projects
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
end
