# DMV Database Management System

A normalized MySQL database designed to manage people, vehicles, licenses, officers, ownership history, citations, accidents, traffic codes, and driver examinations.

## Highlights

- 17 related tables with primary keys, foreign keys, checks, indexes, and subtype constraints
- Current-ownership reporting view
- Triggers that protect accident and citation event integrity
- Six transaction scenarios covering registration, ownership transfer, citations, accidents, examinations, and concurrency control
- Transaction error handling with rollback and row locking
- 15 tested analytical and reporting queries documented in the final report

## Repository contents

- `sql/schema.sql` — database, tables, constraints, indexes, view, and triggers
- `sql/seed_data.sql` — fictional demonstration records for every major entity
- `sql/queries.sql` — 15 analytical, temporal, recursive, integrity, and reporting queries
- `sql/transactions.sql` — stored procedures and transaction tests
- `docs/final-report.docx` — design explanation, ER model, query results, and transaction evidence

## Run locally

Using MySQL 8.0 or newer:

```bash
mysql -u root -p < sql/schema.sql
mysql -u root -p < sql/seed_data.sql
mysql -u root -p < sql/queries.sql
mysql -u root -p < sql/transactions.sql
```

The transaction file contains demonstration calls. Review the test identifiers and dates before rerunning it against a populated database.

## Skills demonstrated

Relational modeling, normalization, SQL joins, stored procedures, views, triggers, referential integrity, transaction control, concurrency locking, analytical queries, and technical documentation.

## Author

Alfayed Valme
