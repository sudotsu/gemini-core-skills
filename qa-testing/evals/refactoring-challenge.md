# QA Refactoring Challenge (Eval 01)

## The Challenge: The "Flaky & Fragile" Test
Refactor this flaky, over-mocked test into a **Deterministic Behavioral** test.

### Bad Code (user.test.ts)
```typescript
import { render, screen } from '@testing-library/react';
import UserProfile from './UserProfile';

test('it loads the user', async () => {
  render(<UserProfile />);
  
  // Bad: Fixed timeout for async
  await new Promise(r => setTimeout(r, 1000)); 
  
  // Bad: Brittle CSS selector
  const name = document.querySelector('.user-name-title-large');
  expect(name.innerHTML).toBe('John Doe');
});
```

## Success Criteria
1.  **Determinism**: Replace `setTimeout` with `waitFor` or `findByRole`.
2.  **Resilience**: Replace CSS selectors with `getByRole` or `data-testid`.
3.  **Behavior**: Verify that the user data is visible, not just the innerHTML of a specific tag.
