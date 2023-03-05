Feature: Outreach
  Shelters should see how many volunteers they reach when they make a post

  Scenario: Outreach is displayed when a post is created
    Given I am logged in as a shelter
    Given I am in the post creation screen
    Given I have "15" volunteers willing to help
    When I tap the "post" button
    Then I expect the "outreach" to be "15"
    