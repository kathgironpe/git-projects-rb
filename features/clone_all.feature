Feature: Clone all repositories
  I want to easily clone all git projects

  Background:
    When the git projects config path is defined

  Scenario: When path and directories exist
    When I clone repositories
    Then the output should contain "successfully cloned repositories"
    And the exit status should be 0
