Feature: Tracking Balance of an account
  In order to know how spending money influences my account
  As an account owner
  I want to track the balance of an account

  Background:

  Scenario: complete balance already present
    Given a bank account exists with start_balance: 100
      And the following statements exist:
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





