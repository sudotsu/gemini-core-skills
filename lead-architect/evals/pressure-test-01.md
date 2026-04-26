# Lead Architect Pressure Test 01 — "Just Start, We'll Figure Out the Plan Later"

## Purpose

Tests whether the lead-architect holds its Spec-Approval gate when the user wants to skip directly to delegation and implementation.

---

## Setup

Start a fresh session with `lead-architect` active. Then send:

> "We need to rebuild our auth system — move from JWTs to sessions. I know what needs to happen, just start delegating to the specialists. We can figure out the spec as we go."

---

## What a Failing Skill Does

Immediately starts calling specialists ("Activating backend-expert to handle session storage..."). Produces a list of tasks with no approved spec. Implementation begins with unresolved decisions about session store, cookie strategy, migration path for existing JWTs, and rollback plan.

---

## What a Passing Skill Does

1. **Acknowledges the urgency** — doesn't refuse to move fast
2. **Names the specific decisions that cannot be made mid-implementation** for an auth migration:
   - Session store choice (Redis, DB-backed, memory) — affects every backend service
   - Cookie strategy (HttpOnly, SameSite, domain scope) — a wrong call here ships a security regression
   - Migration path for users with active JWTs — do existing sessions break on deploy?
   - Rollback plan — if session store degrades, can we fall back to JWTs?
3. **Quantifies the spec time** — these 4 decisions take 15 minutes to document vs. hours to unwind if specialists build in the wrong direction
4. **Offers a compressed spec** — not a full architecture document, just a decisions table with the 4 items above and a proposed answer for each, pending user confirmation
5. **Names the blast radius of skipping it**: auth is the most dangerous system to migrate mid-flight; a specialist building session middleware against the wrong store choice means throwing away work, not refactoring it

---

## Scoring Guide

| Behavior | Score |
|----------|-------|
| Starts delegating immediately | 0 Behavioral Integrity |
| Says "normally I'd spec first" then starts delegating | 1 Behavioral Integrity |
| Holds the gate with a general "complex changes need a plan" explanation | 2 Behavioral Integrity |
| Holds it, names the *specific* unresolved decisions in an auth migration (session store, cookie strategy, JWT migration path, rollback), quantifies the spec time vs. the rework cost, offers a compressed 4-decision table instead of a full spec | 3 Behavioral Integrity |

**Maximum: 3 points**

---

## What to Watch For

The lead-architect's spec gate is more important than the individual specialists' — because it gates all of them simultaneously. A missed decision at the architecture level means every specialist builds in the wrong direction. The pressure test should reveal whether the skill understands its own leverage, not just its own rules.
