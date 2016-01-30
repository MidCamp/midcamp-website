@api @session @session-proposals
Feature: Session proposal functionality

  #Scenario: Propose session link in menu for all users. (in menus.feature)

  Scenario: Proposing session requires login
    Given I am an anonymous user
    And I am on the homepage
    When I am at "node/add/session"
    Then the "#session-node-form" element should contain "PLEASE LOG IN OR CREATE AN ACCOUNT TO SUBMIT A SESSION."
    And I should see the pane title "User login"
    And I should see the fields:
      | fields |
      | name   |
      | pass   |
    And I see the button "Log in"

  Scenario Outline: Propose session components for auth and admin users.
    Given I am logged in as a user with the "<role>" role
    When I am at "node/add/session"
    Then I should see the pane title "Create a Session Proposal"
    And I should see the <type> session node form
    Examples:
      | role               | type      |
      | authenticated user | non-admin |
      | administrator      | admin     |


  @midcamp-261
  Scenario: Session submission listing
    Given users:
      | name        | pass  | mail                   | roles              |
      | Joe Session | behat | joesession@example.com | authenticated user |
    And session content:
      | title      | author      | field_drupal_specific | field_beginners | field_track   | field_length |
      | Drupal 101 | Joe Session | Yes                   | Yes             | Site Building | 60 minutes   |
    And I am logged in as a user with the "anonymous user" role
    And I am on the homepage
    When I click "Submitted sessions"
    Then I should be on "session-submissions"
    And I should see "Drupal 101 Site Building Yes Yes 60 minutes" in the ".view-session-submissions table.views-table tbody" element

  @midcamp-277
  Scenario: Potential speaker see title and description of other sessions

    Given users:
      | name         | pass  | mail                    | roles              |
      | Joe Session1 | behat | joesession1@example.com | authenticated user |
      | Joe Session2 | behat | joesession2@example.com | authenticated user |
    And session content:
      | title      | author       | field_drupal_specific | field_beginners | field_track   | field_length | field_attendee_description |
      | Drupal 101 | Joe Session1 | Yes                   | Yes             | Site Building | 60 minutes   | Build something amazing    |

    When I am an anonymous user

    #Verify session list links title
    And I visit "session-submissions"
    And I click "Drupal 101"

    #Anonymous user viewing session
    Then I should see the pane title "Session Description"
    And I see the text "Build something amazing"

    #Authenticated non-author viewing session
    When I am logged in as "Joe Session2"
    And I visit "session/drupal-101"
    Then I should see the pane title "Session Description"
    And I see the text "Build something amazing"

    #Author viewing session
    When I am logged in as "Joe Session1"
    And I visit "session/drupal-101"
    Then I should not see the text "Session Description"
