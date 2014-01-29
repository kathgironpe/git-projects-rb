Feature: Fetch changes from all remotes
  I want to easily fetch changes from all remotes

  Background:
    When the git projects config path is defined

  Scenario: When path and directories exist
    When I fetch changes from all remotes
    Then the output should contain "successfully fetched changes"
    And the exit status should be 0
