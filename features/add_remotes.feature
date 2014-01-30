Feature: Check all repositories
  I want to easily check if all git projects are cloned or initialized

  Background:
    When I create a config for repositories
    And I add "heroku-test" remote for "a"

  Scenario: Adding a remote given the project and path exists
    When I add remotes
    Then the output should contain "Checking new remotes for a"
    And the output should contain "Added remote heroku-test"
