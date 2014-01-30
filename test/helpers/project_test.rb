require_relative '../test_helper'
require_relative '../../lib/helpers/project'

describe Project do

  let(:project_path) { '/tmp/repos' }
  let(:path) { git_projects_path(project_path) }
  let(:config_path) { File.join(path, 'git-projects.yml') }
  let(:project_path) { '/test/tmp/projects' }

  before do
    clean_projects_path(project_path)
    create_git_projects(project_path)
    GitProject.create_config(path)
    @project = Project.new(config_path)
  end

  describe '#all' do
    context 'when size is called' do
      it 'returns correct number of projects' do
        @project.all.size.must_equal 5
      end
    end

    context 'when group parameter exists' do

      before do
        @project.new_group('a','ruby')
      end

      it 'should filter projects by group' do
        @project.all('ruby').size.must_equal 1
      end
    end
  end

  describe '#first' do
    context 'when there is a root_dir' do
      it 'includes the name of the project' do
        @project.first[0].must_equal 'a'
      end

      it 'should not include the root_dir' do
        @project.first[1].keys.must_include 'root_dir'
      end

      it 'incudes the remotes' do
        @project.first[1]['origin'].must_include project_path
      end
    end

    context 'when there is an all option' do
      it 'should include all option' do
        @project.first[1].keys.must_include 'all'
      end
    end
  end

  describe '#set_root_path' do
    before do
      path = Dir.pwd+project_path
      @project.set_root_path(path)
    end

    context 'when user overrides root_dir' do
      it 'incudes returns new root path' do
        @project.first[1]['root_dir'].must_include project_path
      end
    end

  end

  describe '#new_remote' do
    before do
      @project.new_remote('a','bitbucket', @project.first[1]['origin'])
    end

    context 'when remote is added to an existing project' do
      it 'adds a new remote' do
        @project.first[1]['bitbucket'].must_equal @project.first[1]['origin']
      end
    end
  end

  describe '#new_group' do
    before do
      @project.new_group('a','ruby')
    end

    context 'when a new group is set for existing project' do
      it 'changes the group' do
        @project.first[1]['group'].must_equal 'ruby'
      end
    end
  end
end
