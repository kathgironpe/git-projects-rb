Feature: Check all repositories
  I want to easily check if all git projects are cloned or initialized

  Background:
    When I create a config for repositories

  Scenario: When path and directories exist
    When I check repositories
    Then the output should contain "Checking repositories. If things go wrong, update"
