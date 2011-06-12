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
    

  @wip
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

  @wip
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

