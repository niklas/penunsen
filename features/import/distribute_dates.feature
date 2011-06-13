Feature: Import distributes dates
  In order to have a continous plot
  As an importer
  I do not want the statements of one day be recorded at the same time

  Scenario: 3 statements are 8 hours away
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
