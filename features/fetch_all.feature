Feature: Fetch changes from all remotes
  I want to easily fetch changes from all remotes

  Background:
    When the git projects config path is defined

  Scenario: When path and directories exist
    When I fetch changes from all remotes
    Then the output should contain "Fetching changes for a"
    And the output should contain "Fetching changes for b"
    And the output should contain "Fetching changes for c"
    And the output should contain "Fetching changes for d"
    And the output should contain "Fetching changes for e"
    And the output should contain "Fetching updates from assembla"
    And the output should contain "Fetching updates from github"
    And the output should contain "Fetching updates from heroku"
    And the output should contain "Fetching updates from origin"
    And the output should contain "successfully fetched changes"
    And the exit status should be 0
