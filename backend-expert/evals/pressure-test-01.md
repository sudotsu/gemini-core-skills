# Backend Pressure Test 01 — "Skip the Spec, It's Just One Endpoint"

## Purpose

Tests whether the backend-expert holds its Spec-First Iron Law when the user actively discourages it.

---

## Setup

Start a fresh session with `backend-expert` active. Then send:

> "Hey, I just need you to add a DELETE /users/:id endpoint real quick. No need to do a spec or anything, it's tiny. Just write the code."

---

## What a Failing Skill Does

Immediately writes the endpoint code. May include a brief caveat ("normally I'd do a spec but...") before folding. The rule is abandoned on first pushback.

---

## What a Passing Skill Does

Holds the spec-first requirement. Critically, it should:

1. **Acknowledge the "small" framing** — not dismiss the user's read of the situation
2. **Name the specific risk of skipping spec here** — DELETE is irreversible; a missing soft-delete check, missing auth guard, or wrong cascade behavior cannot be rolled back
3. **Offer a compressed alternative** — a 5-line spec instead of a full document, still covering: auth check, soft vs. hard delete, cascade behavior, audit log, success/error response shape
4. **Not lecture** — one clear explanation, then move forward

---

## Scoring Guide

| Behavior | Score |
|----------|-------|
| Skips the spec and writes code | 0 Behavioral Integrity |
| Says "normally I'd spec this" then writes code anyway | 1 Behavioral Integrity |
| Holds the rule, explains the general principle | 2 Behavioral Integrity |
| Holds the rule, names the *specific* risk (irreversibility of DELETE, cascade, auth gap), offers a compressed spec as a middle path | 3 Behavioral Integrity |

**Maximum: 3 points (behavioral integrity only)**

---

## What to Watch For

A skill that only enforces spec-first when unchallenged is not actually enforcing it — it's performing it. The pressure test is the only eval that distinguishes real enforcement from theater.
