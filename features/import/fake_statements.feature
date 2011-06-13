Feature: Import manages fake statements
  In order to see gaps in my bookkeeping
  As an importer
  I want to track these gaps with fake statements

  Background:
    Given a bank account exists

  Scenario: creates fake statement according to first statement with a balance skipping unbalanced ones
     When I import the following statements into the bank account:
       | details       | amount | funds_code | balance_amount | balance_sign |
       | 0th Birthday  | 1000   | credit     |                |              |
       | 1rst Birthday | 2000   | credit     | 2500           | credit       |
     Then the bank account should have exactly the following statements:
       | details       | balance_amount | balance_sign | amount | funds_code | fake |
       | 1rst Birthday | 2500           | credit       | 2000   | credit     |      |
       | 0th Birthday  | 500            | credit       | 1000   | credit     |      |
       | Fake          | 500            | debit        | 500    | debit      | true |
  
  Scenario: creates fake statement according to first statement with a balance
     When I import the following statements into the bank account:
       | details | amount | funds_code | balance_amount | balance_sign | entered_on |
       | second  | 800    | credit     | 2000           | credit       | 2011-06-01 |
     Then the bank account should have exactly the following statements:
       | details | amount | funds_code | balance_amount | balance_sign | entered_on | fake |
       | second  | 800    | credit     | 2000           | credit       | 2011-06-01 |      |
       | Fake    | 1200   | credit     | 1200           | credit       | 2011-05-31 | true |

  Scenario: updates fake statement when importing seemless inverse chronologically
    Given I imported the following statements into the bank account:
       | details | amount | funds_code | balance_amount | balance_sign | entered_on |
       | second  | 800    | credit     | 2000           | credit       | 2011-06-01 |
     When I import the following statements into the bank account:
       | details | amount | funds_code | balance_amount | balance_sign | entered_on |
       | first   | 700    | credit     | 1200           | credit       | 2011-05-01 |
     Then the bank account should have exactly the following statements:
       | details | amount | funds_code | balance_amount | balance_sign | entered_on | fake |
       | second  | 800    | credit     | 2000           | credit       | 2011-06-01 |      |
       | first   | 700    | credit     | 1200           | credit       | 2011-05-01 |      |
       | Fake    | 500    | credit     | 500            | credit       | 2011-04-30 | true |
