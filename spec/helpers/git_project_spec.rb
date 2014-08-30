require_relative '../spec_helper'
require_relative '../../lib/helpers/git_project'

describe GitProject do

  let(:project_path) { './tmp/repos' }
  let(:path) { git_projects_path(project_path) }
  let(:config_path) { "#{path}/git-projects.yml" }
  let(:directories) { Dir.entries(path) }
  let(:group) { 'anything' }

  before do
    clean_projects_path(project_path)
    create_git_projects(project_path)
    GitProject.create_config(path, group)
  end

  describe '.create_config' do
    context 'when config does not exist' do

      let(:group) { nil }

      it 'creates a git-projects.yml file' do
        config_file = File.open("#{path}/git-projects.yml").read
        expect(config_file).to include 'origin:'
        expect(config_file).to include 'group: repos'
      end
    end

    context 'when config does not exist' do
      it 'creates a git-projects.yml file with group specified' do
        config_file = File.open("#{path}/git-projects.yml").read
        expect(config_file).to include 'group: anything'
      end
    end

    context 'when config exists' do
      it 'returns an exception' do
        expect { GitProject.create_config(path) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#init' do
    before do
      @git = GitProject.new(config_path)
    end

    context 'when root_dir exists and repositories are cloned' do

      it 'clones or initializes repositories on root_dir' do
        @git.init
        expect(directories.size).to eq(8)
      end
    end
  end

  describe '#fetch_all' do

    before do
      @git = GitProject.new(config_path)
      @git.init
    end

    context 'when there is no group' do
      it 'fetches all updates for all remotes' do
        expect(@git.fetch_all.to_s).to include 'github'
        expect(directories.size).to eq(8)
      end
    end

    context 'when there is a group' do

      before do
        @git.new_group('a','ruby')
      end

      it 'fetches all updates for group ruby' do
        expect(@git.fetch_all('ruby').to_s).to include 'github'
        expect(directories.size).to eq(8)
      end
    end
  end

  describe '#add_remotes' do
    context 'when repos are cloned' do
      before do
        @git = GitProject.new(config_path)
        @git.new_remote('a','bitbucket', 'test')
        @git.add_remotes
      end

      it 'adds missing remotes' do
        remotes = Git.open("#{git_projects_path(project_path)}/a").remotes.map(&:name)
        expect(remotes).to include('bitbucket')
      end

      it 'adds an all remote' do
        remotes = Git.open("#{git_projects_path(project_path)}/a").remotes.map(&:name)
        expect(remotes).to include('all')
      end
    end
  end
end
