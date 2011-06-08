Feature: Search for statements
  In order to find out what happened with my money
  As a bank account owner
  I want to scope the statements beeing shown

  Background:
    Given a bank account exists
      And the following statements exist:
        | account          | account_holder  |
        | the bank account | Mom             |
        | the bank account | Coke Dealer     |
        | the bank account | Call Girls Inc. |

  Scenario: not filtering
     When I go to the statements page of the bank_account
     Then I should see the following table:
        | Info            |
        | Mom             |
        | Coke Dealer     |
        | Call Girls Inc. |
