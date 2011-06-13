Feature: Import detects Duplicates
  In order to just throw my csv into the importer
  As an importer
  I want duplicates ignored when importing


  Background:
    Given a bank account exists

  Scenario: do not re-import single duplicate
    Given I imported the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |
     When I import the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Birfdayy Present | 800    | debit      | 1200           | credit       | 2011-05-05 |
     Then the bank account should have exactly the following statements:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on | fake |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |      |
       | Fake             | 2000   | credit     | 2000           | credit       | 2011-05-04 | true |
     

  Scenario: do not re-import multiple duplicates
    Given I imported the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Payday           | 1000   | credit     | 2000           | credit       | 2011-05-03 |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |
     When I import the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | My Payday        | 1000   | credit     | 2000           | credit       | 2011-05-03 |
       | Birfdayy present | 800    | debit      | 1200           | credit       | 2011-05-05 |
     Then the bank account should have exactly the following statements:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on | fake |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |      |
       | Payday           | 1000   | credit     | 2000           | credit       | 2011-05-03 |      |
       | Fake             | 1000   | credit     | 1000           | credit       | 2011-05-02 | true |

  Scenario: import the non-duplicates when importing around existing
    Given I imported the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |
     When I import the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Payday           | 1000   | credit     | 2000           | credit       | 2011-05-03 |
       | Birfdayy present | 800    | debit      | 1200           | credit       | 2011-05-05 |
       | other Present    | 500    | debit      | 700            | credit       | 2011-05-12 |
     Then the bank account should have exactly the following statements:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on | fake |
       | other Present    | 500    | debit      | 700            | credit       | 2011-05-12 |      |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |      |
       | Payday           | 1000   | credit     | 2000           | credit       | 2011-05-03 |      |
       | Fake             | 1000   | credit     | 1000           | credit       | 2011-05-02 | true |


  Scenario: don't re-import duplicates at the end of the import
    Given I imported the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Payday           | 1000   | credit     | 2000           | credit       | 2011-05-03 |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |
       | other Present    | 500    | debit      | 700            | credit       | 2011-05-12 |
     When I import the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |
       | other Present    | 500    | debit      | 700            | credit       | 2011-05-12 |
       | second Payday    | 1000   | credit     | 1700           | credit       | 2011-06-01 |
     Then the bank account should have exactly the following statements:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on | fake |
       | second Payday    | 1000   | credit     | 1700           | credit       | 2011-06-01 |      |
       | other Present    | 500    | debit      | 700            | credit       | 2011-05-12 |      |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |      |
       | Payday           | 1000   | credit     | 2000           | credit       | 2011-05-03 |      |
       | Fake             | 1000   | credit     | 1000           | credit       | 2011-05-02 | true |


  Scenario: don't re-import duplicates at the start of the import
    Given I imported the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Payday           | 1000   | credit     | 2000           | credit       | 2011-05-03 |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |
       | other Present    | 500    | debit      | 700            | credit       | 2011-05-12 |
     When I import the following statements into the bank account:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on |
       | Milk             | 60     | debit      | 1000           | credit       | 2011-05-02 |
       | P4yd4y           | 1000   | credit     | 2000           | credit       | 2011-05-03 |
       | Birthdy Praesent | 800    | debit      | 1200           | credit       | 2011-05-05 |
     Then the bank account should have exactly the following statements:
       | details          | amount | funds_code | balance_amount | balance_sign | entered_on | fake |
       | other Present    | 500    | debit      | 700            | credit       | 2011-05-12 |      |
       | Birthday Present | 800    | debit      | 1200           | credit       | 2011-05-05 |      |
       | Payday           | 1000   | credit     | 2000           | credit       | 2011-05-03 |      |
       | Milk             | 60     | debit      | 1000           | credit       | 2011-05-02 |      |
       | Fake             | 1060   | credit     | 1060           | credit       | 2011-05-01 | true |


