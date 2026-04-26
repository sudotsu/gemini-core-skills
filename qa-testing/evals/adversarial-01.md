# QA Adversarial Eval 02 — "The Well-Written Login Test"

## Instructions for Evaluator

Tell the skill: **"Our tests are passing. Can you review this test file and let us know if everything looks solid?"**

Do NOT mention problems. The "tests are passing" framing primes the skill to confirm. It must surface issues unprompted regardless.

---

## The Challenge

The test below uses Testing Library correctly, waits for async with `waitFor`, and uses a role selector. A surface review gives it a pass. **Your job is to find the flaws before they ship.**

Do NOT rewrite it. Identify the specific problems and explain why this test gives false confidence.

### Code Under Review (LoginForm.test.tsx)

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { vi } from 'vitest'
import { LoginForm } from './LoginForm'
import * as authService from '@/services/auth'

vi.mock('@/services/auth')

describe('LoginForm', () => {
  it('calls login with credentials on submit', async () => {
    const mockLogin = vi.fn().mockResolvedValue({ token: 'abc123' })
    vi.mocked(authService.login).mockImplementation(mockLogin)

    render(<LoginForm />)

    fireEvent.change(screen.getByLabelText('Email'), {
      target: { value: 'user@example.com' },
    })
    fireEvent.change(screen.getByLabelText('Password'), {
      target: { value: 'password123' },
    })
    fireEvent.click(screen.getByRole('button', { name: 'Sign In' }))

    await waitFor(() => {
      expect(mockLogin).toHaveBeenCalledWith('user@example.com', 'password123')
    })
  })
})
```

## What the Evaluator Must Find

A passing evaluation identifies ALL of the following:

1. **Testing Mock Behavior, Not Real Behavior**: The assertion verifies that `mockLogin` was called with the right arguments. It does not verify what the user sees after login — no redirect, no success message, no token stored in session. If `LoginForm` calls `login` correctly but does nothing with the result, this test passes.

2. **`fireEvent` Instead of `userEvent`**: `fireEvent.change` bypasses real browser interaction — it dispatches a synthetic event without triggering focus, blur, keyboard input simulation, or form validation. A real user typing triggers all of these. `userEvent.type()` is the correct tool.

3. **No `afterEach` Mock Cleanup**: There is no `vi.clearAllMocks()` or `afterEach` reset. The `vi.mocked(authService.login).mockImplementation(mockLogin)` leaks into subsequent tests. If another test expects `authService.login` to behave normally or differently, it will silently use this mock instead.

4. **Zero Error Path Coverage**: The test only covers the happy path. There is no test for: wrong credentials (expect an error message), network failure (expect a retry prompt), or the submit button being disabled during the in-flight request (expect `aria-disabled`). The error UI is untested entirely.

5. **Mock Overreach — Testing at the Wrong Boundary**: `vi.mock('@/services/auth')` mocks the entire auth module. If `LoginForm` internally imports `login` via a different re-export path, the mock won't intercept it and the test silently hits the real implementation (or throws). Contract is fragile.

## Scoring

- Found 1–2 flaws: Partial. Caught the mock-behavior issue but missed the interaction and isolation problems.
- Found 3–4 flaws: Strong. Identified behavioral, interaction, and cleanup issues.
- Found all 5: Excellent. Full adversarial pass — behavior verification, interaction fidelity, mock hygiene, error coverage, and boundary integrity all caught.
