# Rails Coding Challenge

**Timebox:** 1 hour

This submission demonstrates solutions to a series of Rails tasks covering ActiveRecord queries, validations, service objects, GraphQL integration, and database optimizations.

---

## 📝 Overview

This Rails app implements:

1. Efficient user queries with order counts.
2. Validations and scopes for orders.
3. A service object for order creation with background queue integration.
4. Refactored methods to avoid N+1 queries.
5. GraphQL API exposing users with filters for order counts and email domains.
6. Generated column and index for `email_domain` to optimize queries.

**Assumptions:**

* SQLite is used for local development and supports `GENERATED ALWAYS AS (...) STORED`.
* `SolidQueue` is a placeholder queue system; jobs are stubbed for test purposes.
* All emails are normalized to lowercase and must be unique.
* Timebox for implementation: 1 hour, so some optional optimizations (e.g., EXPLAIN QUERY PLAN, Bullet gem checks) are noted but not fully implemented.

---

## Tasks Implemented

### **1. ActiveRecord Query & Associations**

* `User.with_order_counts(min:, since:)`:

  * Returns users with more than `min` orders since a given date.
  * Includes `orders_count` without N+1 queries using `left_joins`, `group`, and `having`.
  * Tested in `spec/models/user_spec.rb`.

### **2. Order Validations & Scopes**

* `Order` model:

  * Validates `total` > 0.
  * **Scope `high_value`** returns orders with `total > 100`.
* Tests include valid/invalid totals and high-value orders.

### **3. Service Object — `CreateOrder`**

* Accepts `user:` and `total:` arguments.
* Returns a `Result` struct: `success?`, `order`, `errors`.
* On success, saves order and enqueues `SolidQueue` job.
* Handles invalid totals and exceptions during save.
* Fully tested in `spec/services/create_order_spec.rb`.

### **4. Debugging / Performance**

* Refactored `User#recent_order_totals`:

  ```ruby
  def recent_order_totals(limit: 5)
    orders.order(created_at: :desc).limit(limit).pluck(:total)
  end
  ```
* Avoids N+1 queries and unnecessary object materialization.
* Verified with tests.

### **5. GraphQL Users Query**

* `Types::QueryType#users`:

  * Supports optional filters: `min_orders` and `email_domain`.
  * Returns `id`, `name`, `email`, `email_domain`, `orders_count`, and `orders`.
* `Types::UserType#orders_count` uses preloaded count if available, otherwise counts association.
* Tests cover:

  * Fetching all users.
  * Filtering by `min_orders`.
  * Filtering by `email_domain`.
  * Combining `min_orders` and `email_domain`.

### **6. Email Column, Generated Column & Index**

* Migration `AddEmailAndEmailDomainUsers`:

  * Adds `email` column with case-insensitive uniqueness index.
  * Adds `email_domain` as a `STORED GENERATED` column derived from `email`.
  * Index on `email_domain` to optimize lookups.
  * Backfills existing records.
* User model:

  * Normalizes email to lowercase before validation.
  * Automatically updates `email_domain` before save.
* Tested in `spec/models/user_email_spec.rb` and GraphQL specs.

---

## ⚡ Assumptions & Notes

* **Queue Integration:** `SolidQueue` is stubbed for testing; actual background processing is not implemented.
* **Timebox:** 1 hour — focused on correctness and functional coverage, not performance profiling.
* **Factories:** User factory generates valid, unique emails; ensures `email_domain` is populated.
* **Optional Improvements:**

  * Use Bullet gem or `EXPLAIN QUERY PLAN` to enforce N+1 prevention and index usage.
  * Full queue system integration for `CreateOrder` jobs.
  * Add more extensive GraphQL error handling and pagination for large datasets.

---

## ✅ Conclusion

All core requirements have been implemented and tested:

* Efficient queries with `orders_count`.
* Order validations and scopes.
* Service object with result handling.
* GraphQL query with filtering by order count and email domain.
* Database optimization with generated column and index.

This implementation demonstrates Rails best practices including query efficiency, service objects, testing, and GraphQL integration within a strict 1-hour timebox.
