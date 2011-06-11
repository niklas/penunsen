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
