require 'minitest/autorun'
require 'git'
require_relative 'test_repos'

class MiniTest::Spec

  class << self
    alias_method :context, :describe
  end

  include TestRepos

end
