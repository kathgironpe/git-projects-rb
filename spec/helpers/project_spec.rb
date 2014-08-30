require_relative '../spec_helper'
require_relative '../../lib/helpers/project'

describe Project do

  let(:project_path) { './tmp/repos' }
  let(:path) { git_projects_path(project_path) }
  let(:config_path) { File.join(path, 'git-projects.yml') }

  before do
    clean_projects_path(project_path)
    create_git_projects(project_path)
    GitProject.create_config(path)
    @project = Project.new(config_path)
  end

  describe '#all' do
    context 'when size is called' do
      it 'returns correct number of projects' do
        expect(@project.all.size).to eq(5)
      end
    end

    context 'when group parameter exists' do

      before do
        @project.new_group('a','ruby')
      end

      it 'should filter projects by group' do
        expect(@project.all('ruby').size).to eq(1)
      end
    end
  end

  describe '#first' do
    context 'when there is a root_dir' do
      it 'includes the name of the project' do
        expect(@project.first[0]).to eq('a')
      end

      it 'should not include the root_dir' do
        expect(@project.first[1].keys).to include 'root_dir'
      end

      it 'incudes the remotes' do
        expect(@project.first[1]['origin']).to include project_path
      end
    end

    context 'when there is an all option' do
      it 'should include all option' do
        expect(@project.first[1].keys).to include 'all'
      end
    end
  end

  describe '#create_root_path' do
    before do
      path = Dir.pwd+project_path
      @project.create_root_path(path)
    end

    context 'when user overrides root_dir' do
      it 'incudes returns new root path' do
        expect(@project.first[1]['root_dir']).to include project_path
      end
    end

  end

  describe '#new_remote' do
    before do
      @project.new_remote('a','bitbucket', @project.first[1]['origin'])
    end

    context 'when remote is added to an existing project' do
      it 'adds a new remote' do
        expect(@project.first[1]['bitbucket']).to eq(@project.first[1]['origin'])
      end
    end
  end

  describe '#new_group' do
    before do
      @project.new_group('a','ruby')
    end

    context 'when a new group is set for existing project' do
      it 'changes the group' do
        expect(@project.first[1]['group']).to eq('ruby')
      end
    end
  end
end
