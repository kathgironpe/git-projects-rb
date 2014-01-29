Feature:  Create config feature
  I want to easily clone all git projects

  Background:
    When the git projects config path does not exist

  Scenario: When git repositories exist
    When I create a config for repositories
    Then the output should contain "successfully created git-projects.yml"
    And the exit status should be 0
