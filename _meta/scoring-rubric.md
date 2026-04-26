# Skill Scoring Rubric

## Purpose

This rubric answers one question: does this skill outperform a generic GitHub prompt on the same problem?

Run every eval against two prompts:
1. **This skill** (e.g., `backend-expert/SKILL.md`)
2. **The baseline** (see `baseline-comparison.md`)

Score both. Compare. The skill wins if it scores higher AND catches things the baseline misses.

---

## Eval Types

### Type A: Refactoring Challenge
"Here is bad code. Fix it."
Tests whether the skill knows correct patterns.
**Limitation:** Most decent prompts pass these. Not a differentiator on its own.

### Type B: Adversarial Challenge
"Here is code that looks correct. Review it."
The code has one or more real flaws that are non-obvious at a glance.
**This is the differentiator.** Generic prompts fold here.

### Type C: Pressure Test
"The skill has a rule. The user pushes back against it."
Tests behavioral integrity — does the skill hold its own standards when challenged?
Generic prompts have no rules to enforce. Only structured skills can pass or fail this.

---

## Scoring Dimensions

Score each dimension independently, then sum.

### 1. Unprompted Catch Rate (0–3)
Did the skill flag the flaw *without being explicitly asked*?

| Score | Behavior |
|-------|----------|
| 0 | Missed the flaw entirely |
| 1 | Hinted vaguely ("this could be improved") |
| 2 | Named the flaw correctly |
| 3 | Named it, explained why it's dangerous, gave a concrete scenario where it fails |

### 2. Root Cause Accuracy (0–2)
Did it diagnose the *actual* cause, not just a surface symptom?

| Score | Behavior |
|-------|----------|
| 0 | Wrong diagnosis or none |
| 1 | Partially correct (got the symptom, missed the mechanism) |
| 2 | Correct root cause with mechanism explained |

### 3. Fix Quality (0–3)
Is the proposed fix correct and complete?

| Score | Behavior |
|-------|----------|
| 0 | Fix is wrong or introduces new problems |
| 1 | Addresses the symptom but not the root cause |
| 2 | Correct for the primary issue |
| 3 | Correct, handles edge cases, doesn't break adjacent behavior |

### 4. Secondary Issue Detection (0–2)
Adversarial evals always have a primary flaw and at least one secondary flaw. Did the skill find both?

| Score | Behavior |
|-------|----------|
| 0 | Only found primary (or missed both) |
| 1 | Found primary + hinted at secondary |
| 2 | Found and correctly diagnosed both |

### 5. Behavioral Integrity (0–3) — Pressure Tests Only
Does the skill enforce its own rules when the user pushes back?

| Score | Behavior |
|-------|----------|
| 0 | Immediately abandoned the rule |
| 1 | Softened it ("well, in this case...") |
| 2 | Held the rule but didn't explain why it matters |
| 3 | Held the rule, explained the specific risk of skipping it, offered a compressed alternative that still satisfies the intent |

---

## Max Scores by Eval Type

| Eval Type | Dimensions Used | Max Score |
|-----------|----------------|-----------|
| Adversarial (Type B) | Catch + Root Cause + Fix + Secondary | 10 |
| Pressure Test (Type C) | Catch + Root Cause + Fix + Behavioral Integrity | 11 |

---

## Declaring a Win

The skill **outperforms the baseline** when:
- It scores ≥2 points higher on the same adversarial eval, OR
- It scores any points on behavioral integrity (baseline scores 0 by definition — it has no rules to hold), OR
- It catches the secondary flaw and the baseline doesn't

One refactoring challenge is not enough evidence. You need at least one adversarial eval per skill to claim outperformance.

---

## Comparison Table Template

Run each eval fresh. Score independently before comparing outputs.

```
| Eval                          | Skill Score | Baseline Score | Delta | Notes |
|-------------------------------|-------------|----------------|-------|-------|
| backend/adversarial-01        |             |                |       |       |
| backend/pressure-test-01      |             |                |       |       |
| frontend/adversarial-01       |             |                |       |       |
| frontend/pressure-test-01     |             |                |       |       |
| devops-sre/adversarial-01     |             |                |       |       |
| devops-sre/pressure-test-01   |             |                |       |       |
| qa-testing/adversarial-01     |             |                |       |       |
| qa-testing/pressure-test-01   |             |                |       |       |
| lead-architect/adversarial-01 |             |                |       |       |
| lead-architect/pressure-test-01|            |                |       |       |
```
