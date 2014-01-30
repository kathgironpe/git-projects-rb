Feature: Fetch changes from all remotes
  I want to easily fetch changes from all remotes

  Background:
    When I create a config for repositories

  Scenario: When I fetch changes for all projects
    When I fetch changes from all remotes
    Then the output should contain "Fetching changes for a"
    And the output should contain "Fetching changes for b"
    And the output should contain "Fetching changes for c"
    And the output should contain "Fetching changes for d"
    And the output should contain "Fetching changes for e"
    And the output should contain "Fetching updates from assembla"
    And the output should contain "Fetching updates from origin"
    And the output should contain "Fetching updates from github"

  Scenario: When I fetch changes for a group
    When I change the group for "a" to "ruby"
    And I fetch changes from all remotes for "ruby" projects
    Then the output should contain "Fetching changes for a"
    And the output should not contain "Fetching changes for b"
    And the output should not contain "Fetching changes for c"
    And the output should not contain "Fetching changes for d"
    And the output should not contain "Fetching changes for e"
