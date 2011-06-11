Feature: Tracking Balance of an account
  In order to know how spending money influences my account
  As an account owner
  I want to track the balance of an account

  Background:
    Given a bank account exists

  Scenario: complete balance already present
    Given the following statements exist:
        | account          | amount | funds_code | balance_amount | balance_sign |
        | the bank account | 100    | credit     | 200            | credit       |
        | the bank account | 50     | debit      | 150            | credit       |
        | the bank account | 20     | credit     | 170            | credit       |
     When I go to the statements page of the bank_account
     Then I should see the following statement data:
        | balance |
        | 100     |
        | 200     |
        | 150     |
        | 170     |

  Scenario: big hole at the end
    Given the following statements exist:
        | account          | amount | funds_code | balance_amount | balance_sign |
        | the bank account | 100    | credit     | 200            | credit       |
        | the bank account | 50     | debit      | 150            | credit       |
        | the bank account | 30     | debit      |                |              |
        | the bank account | 20     | credit     |                |              |
     When I go to the statements page of the bank_account
     Then I should see the following statement data:
        | balance |
        | 100     |
        | 200     |
        | 150     |
        | 120     |
        | 140     |

  Scenario: hole at the beginning
    Given the following statements exist:
        | account          | amount | funds_code | balance_amount | balance_sign |
        | the bank account |  50    | credit     |                |              |
        | the bank account | 100    | credit     | 200            | credit       |
     When I go to the statements page of the bank_account
     Then I should see the following statement data:
        | balance |
        | 50      |
        | 100     |
        | 200     |





