Feature: Search for statements
  In order to find out what happened with my money
  As a bank account owner
  I want to scope the statements beeing shown

  Background:
    Given a bank account exists
      And the following statements exist:
        | account          | account_holder  | entered_on |
        | the bank account | Mom             | 2010-12-01 |
        | the bank account | Coke Dealer     | 2010-12-03 |
        | the bank account | Call Girls Inc. | 2010-12-05 |
      And I am on the statements page of the bank_account

  Scenario: show recent first
     Then I should see the following table:
        | Info            |
        | Call Girls Inc. |
        | Coke Dealer     |
        | Mom             |

  Scenario: before
     When I drag the "before" slider to "2010-12-04"
      And I press "Filter"
     Then I should see the following table:
        | Info            |
        | Coke Dealer     |
        | Mom             |

  Scenario: after
     When I drag the "after" slider to "2010-12-02"
      And I press "Filter"
     Then I should see the following table:
        | Info            |
        | Call Girls Inc. |
        | Coke Dealer     |

  Scenario: before and after
     When I drag the "before" slider to "2010-12-04"
      And I drag the "after" slider to "2010-12-02"
      And I press "Filter"
     Then I should see the following table:
        | Info            |
        | Coke Dealer     |
