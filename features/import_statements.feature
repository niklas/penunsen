Feature: Import Statements
  In order save typing
  As a bank account owner
  I want to import statements in bulk

  Scenario: Distribute date of entering over the whole day for continuous plot
    Given a bank account exists
     When I import the following statements into the bank account:
       | details  | entered_on |
       | Donald   | 1999-09-01 |
       | Tick     | 1999-09-03 |
       | Trick    | 1999-09-03 |
       | Track    | 1999-09-03 |
       | Dagobert | 1999-09-05 |
     Then the bank account should have exactly the following statements:
       | details  | entered_on | entered_at       |
       | Dagobert | 1999-09-05 | 1999-09-05 12:00 |
       | Track    | 1999-09-03 | 1999-09-03 20:00 |
       | Trick    | 1999-09-03 | 1999-09-03 12:00 |
       | Tick     | 1999-09-03 | 1999-09-03 04:00 |
       | Donald   | 1999-09-01 | 1999-09-01 12:00 |

  Scenario: Fills in resulting balance for every statement
    Given a bank account exists with start_balance: 100, start_balance_sign: "credit"
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
    

 Scenario: guesses account's start balance from first statement with a balance
    Given a bank account exists with start_balance: nil, start_balance_sign: nil
     When I import the following statements into the bank account:
       | details       | amount | funds_code | balance_amount | balance_sign |
       | 0th Birthday  | 1000   | credit     |                |              |
       | 1rst Birthday | 2000   | credit     | 2500           | credit       |
     Then the bank account should have exactly the following statements:
       | details       | balance_amount | balance_sign |
       | 1rst Birthday | 2500           | credit       |
       | 0th Birthday  | 500            | credit       |
      And the bank_account's start_balance_with_sign should be -500

  Scenario: guesses account's start balance from amount of first entry if no balances in statements
    Given a bank account exists with start_balance: nil, start_balance_sign: nil
     When I import the following statements into the bank account:
       | details      | amount | funds_code |
       | 0th Birthday | 1000   | credit     |
     Then the bank account should have exactly the following statements:
       | details      | balance_amount | balance_sign |
       | 0th Birthday | 1000           | credit       |
      And the bank_account's start_balance_with_sign should be 0

