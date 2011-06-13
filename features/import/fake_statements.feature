Feature: Import manages fake statements
  In order to see gaps in my bookkeeping
  As an importer
  I want to track these gaps with fake statements
  
  Scenario: creates fake statement according to first statement with a balance
    Given a bank account exists
     When I import the following statements into the bank account:
       | details       | amount | funds_code | balance_amount | balance_sign |
       | 0th Birthday  | 1000   | credit     |                |              |
       | 1rst Birthday | 2000   | credit     | 2500           | credit       |
     Then the bank account should have exactly the following statements:
       | details       | balance_amount | balance_sign | amount | funds_code | fake |
       | 1rst Birthday | 2500           | credit       | 2000   | credit     |      |
       | 0th Birthday  | 500            | credit       | 1000   | credit     |      |
       | Fake          | 500            | debit        | 500    | debit      | true |

