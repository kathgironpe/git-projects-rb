require 'git'

module TestRepos

  def repos_path(project_path)
    "#{Dir.pwd}/#{project_path}"
  end

  def clean_projects_path(project_path)
    path = repos_path(project_path)
    `rm -rf #{path}`
  end

  def git_projects_path(project_path)
    path = repos_path(project_path)
    FileUtils.mkdir_p(path) unless File.directory?(path)
    path
  end

  def create_git_projects(project_path)
    remotes = ['origin','github','assembla','heroku']
    ['a','b','c','d', 'e'].each do |p|
      path = git_projects_path(project_path)
      git_path = "#{path}/#{p}"
      g = Git.init(git_path)
      remotes.each do |r|
        g.add_remote(r, git_path)
      end
    end
  end

  def add_remote(project, name, url=nil)
    unless File.exists?(ENV['GIT_PROJECTS'])
      GitProject.create_config(ENV['GIT_PROJECTS'].gsub('git-projects.yml', ''))
    end

    @project = Project.new(ENV['GIT_PROJECTS'])
    @project = @project.new_remote(project, name, @project.first[1]['origin'])
    `rm #{ENV['GIT_PROJECTS']}` if File.exists?(ENV['GIT_PROJECTS'])
    File.open(ENV['GIT_PROJECTS'], "w") do |f|
      f.write @project.to_yaml.gsub(/- /, '').gsub(/    /, '  ').gsub(/---/, '')
    end
  end

  def change_group(project, name)
    unless File.exists?(ENV['GIT_PROJECTS'])
      GitProject.create_config(ENV['GIT_PROJECTS'].gsub('git-projects.yml', ''))
    end

    @project = Project.new(ENV['GIT_PROJECTS'])
    @project = @project.new_group(project, name)
    `rm #{ENV['GIT_PROJECTS']}` if File.exists?(ENV['GIT_PROJECTS'])
    File.open(ENV['GIT_PROJECTS'], "w") do |f|
      f.write @project.to_yaml.gsub(/- /, '').gsub(/    /,'  ').gsub(/---/, '')
    end
  end
end
