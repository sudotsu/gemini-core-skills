# Backend Security & Performance Mastery

## 1. Security-by-Design (OWASP Top 10)
- **Broken Access Control**: Implement Role-Based Access Control (RBAC) at the service layer, not just the router. Always verify ownership of resources (IDOR prevention).
- **Injection**: Use parameterized queries or ORM features. NEVER concatenate strings for SQL or NoSQL queries.
- **Cryptographic Failures**: Use Argon2 or bcrypt for passwords. Force TLS 1.3 in transit.
- **Security Logging**: Log security events (login failures, unauthorized access) but NEVER log PII or credentials.

## 2. Database Performance
- **The N+1 Problem**: Use eager loading (`JOIN`, `select_related`) to avoid making $N$ extra queries for related data.
- **Indexing Strategy**:
  - **B-Tree**: For equality and range queries.
  - **GIN/GiST**: For full-text search or JSONB fields.
  - **Composite Indexes**: For queries filtering on multiple columns (order matters: filter columns first).
- **Connection Management**: Use connection pools and ensure connections are released promptly.

## 3. API Resilience
- **Rate Limiting**: Protect endpoints from brute-force and DoS attacks using sliding window or token bucket algorithms.
- **Circuit Breaker**: Prevent a failing downstream service from cascading failures across the system.
- **Graceful Shutdown**: Handle `SIGTERM` to finish current requests and close DB connections cleanly.

## 4. Data Integrity
- **ACID Transactions**: Use transactions for operations involving multiple related changes.
- **Isolation Levels**: Be aware of the trade-offs between `Read Committed` and `Serializable` to prevent race conditions.
- **Soft Deletes**: Use `deleted_at` timestamps instead of hard deletes when audit trails or recovery are required.
