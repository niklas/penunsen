Feature: Import fills in balance
  In order to track the balance of the account
  As an importer
  I want that all statements track the accounts's balance


  Scenario: assumes no previous statements if no balances in statements
    Given a bank account exists
     When I import the following statements into the bank account:
       | details      | amount | funds_code |
       | 0th Birthday | 1000   | credit     |
     Then the bank account should have exactly the following statements:
       | details      | balance_amount | balance_sign | amount | funds_code | fake |
       | 0th Birthday | 1000           | credit       | 1000   | credit     |      |

  Scenario: No balances given with a previous fake statement
    Given a bank account exists
      And the following statements exist:
        | account          | details | amount | funds_code | balance_amount | balance_sign | fake |
        | the bank account | Fake    | 100    | credit     | 100            | credit       | true |
     When I import the following statements into the bank account:
       | details | amount | funds_code |
       | Lottery | 1000   | credit     |
       | Taxes   | 190    | debit      |
       | Donate  | 500    | debit      |
       | Stolen  | 2000   | debit      |
       | Welfare | 500    | credit     |
     Then the bank account should have exactly the following statements:
       | details | balance_amount | balance_sign |
       | Welfare | 1090           | debit        |
       | Stolen  | 1590           | debit        |
       | Donate  | 410            | credit       |
       | Taxes   | 910            | credit       |
       | Lottery | 1100           | credit       |
       | Fake    | 100            | credit       |
    
