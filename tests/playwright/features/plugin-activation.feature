@plugin-pipeline
Feature: Plugin activation and WordPress admin

  Background:
    Given I am logged in to the WordPress site

  @activation
  Scenario: Plugin is listed in the plugins page
    When I navigate to "/wp-admin/plugins.php"
    Then I should see "Rossum's Universal Robots"

  @admin
  Scenario: WordPress dashboard loads correctly
    When I navigate to "/wp-admin/"
    Then I should see "Dashboard"
    And the URL should contain "wp-admin"
