# Rails Coding Challenge

Welcome! This challenge is designed to take **45–60 minutes**.
It tests your ability to work with queries, validations, refactoring, and debugging in a Rails app.

---

## Tasks

### Task 1: ActiveRecord Query & Associations
Implement a class method on `User` that returns all users who have placed more than N orders since a given date, with the count available as `orders_count`.

- Implement `.with_order_counts(min:, since:)` using `joins`, `group`, `having`.
- Ensure no N+1 queries when reading `orders_count`.
- Add/complete tests in `spec/models/user_spec.rb`.

### Task 2: Validations & Scopes
In the `Order` model:
1. Validate that `total` is positive.
2. Add a scope `.high_value` returning orders with totals > 100.

- Add/complete tests in `spec/models/order_spec.rb`.

### Task 3: Service Object
Create `CreateOrder` service in `app/services/create_order.rb`:

- Accepts a `user:` and `total:`.
- Validates input; returns success/failure object.
- On success, creates an order (optionally enqueue background work).

- Add/complete tests in `spec/services/create_order_spec.rb`.

### Task 4: Debugging / Performance
The method below is inefficient and may cause extra queries:

```ruby
def recent_order_totals
  orders.last(5).map(&:total)
end
```

- Explain why it’s inefficient.
- Refactor to avoid N+1 queries and unnecessary object materialization.
- Add expectations in `spec/models/user_spec.rb`.

### Task 5: GraphQL Users Query
Implement a GraphQL query that fetches users with:

- `id`, `name`, `orders_count`, and `orders` list
- Optional `min_orders` argument to filter users

- Add/complete tests in `spec/requests/graphql_spec.rb`.

---

### Task 6: Email, Generated Column & Index (SQL + GraphQL)

**Goal:** Extend the `users` table to support efficient filtering by email domain.

---

#### Steps

1. **Add an `email` column** to the `users` table.
   - Validate presence and format.
   - Enforce **case-insensitive uniqueness** (both in the model and at the DB level).
   - Normalize to lowercase before save.

2. **Add a STORED generated column** `email_domain` on `users`.
   - Derive it from the `email` (the part after `@`, lowercased).
   - Example: `user@example.com` → `example.com`.

3. **Index the generated column.**
   - Create a DB index on `email_domain` to speed up lookups.

4. **Migrate and backfill.**
   - Ensure existing users have valid `email` values and domains populated.

5. **Expose in GraphQL.**
   - Add an optional `emailDomain:` argument to the `users` query.
   - Filter results by `email_domain`, and ensure this works together with `minOrders:` from Task 1.

---

#### Deliverables

- Migration(s) adding `email`, validations, the generated column, and index.
- Specs for:
  - Email validation and uniqueness.
  - `email_domain` is derived and kept in sync when `email` changes.
  - `EXPLAIN QUERY PLAN` shows the index is used on a filter by domain.
  - GraphQL query with `emailDomain:` alone and combined with `minOrders:`.
- **Update the User factory and seeds** to generate valid, unique, lowercased emails so validations pass and `email_domain` is populated.

---

#### Constraints

- Use `GENERATED ALWAYS AS (...) STORED` so the column can be indexed in SQLite.
- Generated expression must be **deterministic** and row-local (no subqueries).
- Keep validations case-insensitive.

---


### Notes for Candidates
- Aim to finish the first 3 tasks (~35–45 min); attempt Tasks 4–5 if time allows.
- You can use Bullet warnings to guide N+1 fixes. Warnings are logged to `log/bullet.log` and the Rails log.
- Prefer DB-driven solutions over Ruby loops for counts.

Good luck 🚀
