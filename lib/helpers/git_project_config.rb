# Create YML config
module GitProjectConfig
  def self.included(base)
    base.extend ClassMethods
  end

  # Create YML config
  module ClassMethods
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
      puts "Checking repositories. If things go wrong,
              update #{ENV['GIT_PROJECTS']}".green

      fail "Please add the path your git projects config. \n
              export GIT_PROJECTS=/path/to/git_projects.yml" unless ENV['GIT_PROJECTS']
    end

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

    # Create hash for the project
    def project_info_hash(dir, project, group)
      g = Git.open(File.join(dir, project))
      p = {}
      p.tap do |pr|
        pr[project] = add_remotes_to_hash(g, dir)
        pr[project]['group'] = group
      end
    end

    def create_project_info_hash(projects, dir, group, config_file)
      Dir.entries(dir)[2..-1].each do |project|
        projects << project_info_hash(dir, project, group)
        create_yaml_file(config_file, projects)
      end
    end

    # Create a configuration file based on a root path
    def create_config(dir, group = nil)
      dir = dir.respond_to?(:first) ? dir.first : dir
      config_file = File.join(dir, 'git-projects.yml')
      group ||= dir.split(File::SEPARATOR).last if dir
      fail "The config file, #{config_file} exists" if File.exist?(config_file)
      projects = []
      create_project_info_hash(projects, dir, group, config_file)
      puts "You can later fetch changes through:
            \ngit-projects fetch #{group}".green
    end
  end
end
