# Elite QA & Testing Strategy

## 1. Anti-Flakiness & Determinism
**The Goal**: Zero "random" failures in CI/CD.
- **Wait-for-State**: NEVER use `setTimeout` or `sleep`. Use "wait-for" utilities (e.g., `waitFor` in Testing Library) that poll for a condition.
- **Stable Selectors**: In E2E/Integration, prefer `data-testid` or ARIA roles (`getByRole`). Avoid brittle CSS classes or XPath.
- **Isolate Side Effects**: Ensure every test starts with a clean state. Use `beforeEach` to reset databases or mocks.

## 2. Testing "The Gap" (Integration & Contract)
**The Goal**: Catch bugs where services meet.
- **Contract Testing**: For microservices, use Contract Tests (e.g., Pact) to ensure the Consumer and Provider agree on the API schema.
- **Real DBs for Integration**: Use Testcontainers or lightweight local DBs (SQLite) for integration tests instead of mocking the entire database layer.
- **Mock External APIs**: Only mock what you don't control (e.g., Stripe, AWS).

## 3. Visual & A11y Automation
**The Goal**: Catch what functional tests miss.
- **Automated Accessibility**: Integrate `axe-core` into your test suite to catch 40%+ of accessibility issues automatically.
- **Visual Snapshots**: Use visual regression tools to catch unintended layout shifts or color changes.

## 4. Property-Based Testing (PBT)
**The Goal**: Find the "unthinkable" edge cases.
- Use tools like `fast-check` to run functions with hundreds of randomized inputs (null, extreme values, special characters) to ensure mathematical robustness.

## 5. Behavioral vs. Implementation Testing
**The Goal**: Refactor code without breaking tests.
- **Test Outcomes**: Verify that the user sees "Success", not that `component.internalMethod()` was called.
- **Black-Box Mindset**: Treat the unit under test as a black box. If the output is correct, the test should pass regardless of the internal refactoring.
