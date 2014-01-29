require_relative '../test_helper'
require_relative '../../lib/helpers/git_project'

describe GitProject do

  let(:project_path) { '/tmp/repos' }
  let(:path) { git_projects_path(project_path) }
  let(:config_path) { "#{path}/git-projects.yml" }

  before do
    clean_projects_path(project_path)
    create_git_projects(project_path)
    GitProject.create_config(path)
  end

  describe '.create_config' do
    context 'when config does not exist' do
      it 'creates a git-projects.yml file' do
        File.open("#{path}/git-projects.yml").read.must_include 'origin'
      end
    end

    context 'when config exists' do
      it 'returns an exception' do
        assert_raises(RuntimeError) { GitProject.create_config(path) }
      end
    end
  end

  describe '#clone_all' do
    before do
      @git = GitProject.new(config_path)
    end

    context 'when root_dir exists' do

      let(:directories) { Dir.entries(path) }

      it 'clones repositories on root_dir' do
        @git.clone_all
        directories.size.must_equal 8
      end
    end
  end

  describe '#fetch_all' do
    context 'when repos are cloned' do
      before do
        @git = GitProject.new(config_path)
        @git.clone_all
      end

      let(:directories) { Dir.entries(path) }

      it 'fetches all updates for all remotes' do
        @git.fetch_all.must_equal true
        directories.size.must_equal 8
      end
    end
  end

end
