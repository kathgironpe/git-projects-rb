require 'git'

module TestRepos

  def clean_projects_path(project_path)
    path = Dir.pwd+project_path
    `rm -rf #{path}`
  end

  def git_projects_path(project_path)
    path = Dir.pwd+project_path
    `mkdir -p #{path}` unless File.directory?(path)
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

end
