# Backend Adversarial Eval 02 — "The Looks-Correct Registration Endpoint"

## Instructions for Evaluator

Tell the skill: **"Please review this user registration endpoint for correctness."**

Do NOT say "find the bugs." Do NOT hint that anything is wrong. The skill must surface issues unprompted.

---

## The Challenge

The code below passes a basic review. It uses proper validation, proper password hashing, and avoids returning sensitive fields. **Your job is to find the flaws before they ship.**

Do NOT refactor. Identify the specific bugs and explain exactly what goes wrong at runtime.

### Code Under Review (userController.ts)

```typescript
import { Request, Response } from 'express';
import argon2 from 'argon2';
import { CreateUserSchema } from '../schemas/user';
import { userRepo } from '../repos/userRepo';
import { emailService } from '../services/emailService';

export async function registerUser(req: Request, res: Response) {
  const parsed = CreateUserSchema.parse(req.body); // ✓ Zod validation

  const existing = await userRepo.findByEmail(parsed.email);
  if (existing) {
    return res.status(409).json({ error: 'Email already registered' });
  }

  const hashed = await argon2.hash(parsed.password); // ✓ proper hashing

  const user = await userRepo.db.transaction(async (trx) => {
    return trx('users')
      .insert({ name: parsed.name, email: parsed.email, password: hashed })
      .returning(['id', 'email', 'created_at']); // ✓ no password leak
  });

  await emailService.sendWelcome(user[0].email); // send welcome email

  return res.status(201).json(user[0]);
}
```

## What the Evaluator Must Find

A passing evaluation identifies ALL of the following:

1. **TOCTOU Race Condition**: The `findByEmail` check runs outside the transaction. Two concurrent registrations with the same email both pass the check, then both try to insert. If the DB has a unique constraint on `email`, one throws an unhandled error; if it doesn't, you get duplicate accounts.

2. **Unhandled Side Effect After Commit**: `emailService.sendWelcome` runs outside the transaction after the user is committed to the DB. If it throws, the user record exists but never received a welcome email, and the caller gets a 500. The caller retries, but the user already exists — they now get a 409 and are stuck.

3. **No Idempotency Protection**: There is no idempotency key. A network timeout between commit and 201 response causes the client to retry, hitting the 409 case even for a legitimate first attempt.

4. **Unhandled Transaction Error**: The Knex `.transaction()` error (e.g., unique constraint violation from the race) propagates as an unhandled exception with no specific error response — the client gets a 500 with a DB stack trace.

## Scoring

- Found 1–2 flaws: Partial. The obvious issues were visible but the concurrency angle was missed.
- Found 3 flaws: Strong. Covers the runtime failure paths.
- Found all 4: Excellent. Full adversarial pass — concurrency, side effects, idempotency, and error surface all caught.
