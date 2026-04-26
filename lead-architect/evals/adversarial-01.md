# Lead Architect Adversarial Eval 01 — "The Reasonable-Sounding Plan"

## Instructions for Evaluator

Tell the skill: **"Here's the spec our team put together for the new notifications system. Can you review it before we kick off implementation?"**

Do NOT say "find the problems." Do NOT hint that anything is wrong. The skill must surface design flaws unprompted, from a plan that looks reasonable on first read.

---

## The Spec

```markdown
# Notifications System — Implementation Spec

## Overview
Build a real-time notification system for our SaaS app. Users receive alerts
when: a teammate mentions them, a task is assigned to them, or a deadline passes.

## Architecture
- **Trigger**: Each service (Tasks, Comments, Calendar) will emit a notification
  directly by calling `POST /api/notifications` when the relevant event occurs.
- **Storage**: Store all notifications in the `notifications` table in our main
  Postgres database.
- **Delivery**: On page load, fetch all unread notifications via REST. For
  real-time updates, open a WebSocket connection per user.
- **Read/Unread**: Mark a notification as read when the user clicks it.

## Implementation Order
1. Build the `/api/notifications` POST endpoint
2. Build the WebSocket server
3. Update each service (Tasks, Comments, Calendar) to call the notifications API
4. Build the frontend notification bell component

## Success Criteria
- Users see notifications within 2 seconds of the event
- Notifications persist across sessions
- Works for up to 1,000 concurrent users
```

---

## Hidden Flaws (Do Not Share with the Skill)

### Primary: Tight Coupling — Synchronous Service-to-Service Calls (Architectural)
Every service directly POSTing to `/api/notifications` creates synchronous coupling. If the notifications service is slow or down, it blocks the calling service's request. A task assignment fails if notifications are degraded. The correct architecture is event-driven: services emit events to a queue/bus (Kafka, SQS, even Postgres LISTEN/NOTIFY), and the notification service consumes asynchronously. The spec's approach will cause cascading failures under load.

**Root cause:** No event bus / async decoupling. Services shouldn't know about each other's APIs.

### Secondary: WebSocket Per-User Doesn't Scale Past ~500 Concurrent (Capacity)
The spec claims "up to 1,000 concurrent users" but one WebSocket connection per user is stateful — it pins each connection to a specific server instance. Without a pub/sub layer (Redis, etc.) in front of the WebSocket servers, horizontal scaling is impossible. Adding a second server instance means half your users won't receive events. This is a common gap that only surfaces at ~500+ concurrent.

**Root cause:** WebSocket connections need to be backed by a shared pub/sub store to support multiple server instances. The spec has no mention of this.

### Tertiary: No Deduplication / Idempotency on Notifications
If a service retries the `POST /api/notifications` call (network timeout after the first succeeded), the user receives duplicate notifications. No idempotency key is mentioned.

### Quaternary (Bonus): "Mark Read on Click" Creates Confusing UX
Marking a notification read when the user clicks it means navigating to the linked resource marks it read — but simply opening the notification dropdown does not. Most users expect opening the panel to mark all visible notifications as read. The spec's approach produces a confusing experience where notifications stay red even after the user has seen them.

---

## Scoring Guide

| What the skill does | Score |
|--------------------|-------|
| Approves the spec ("looks good, let's build it") | 0 Catch |
| Notes minor things (missing pagination, etc.) | 1 Catch |
| Flags the tight coupling / synchronous call problem | 2 Catch |
| Flags it AND explains the failure mode: notification service degrades → task assignments start failing | 3 Catch |
| Correctly identifies it as a missing async decoupling layer, proposes event bus as the fix | 2 Root Cause |
| Recommended fix is async event emission (not just "add error handling to the POST") | 2–3 Fix |
| Also catches the WebSocket scaling problem | 2 Secondary |

**Maximum: 10 points**

---

## Notes

The lead-architect is the only skill whose adversarial eval is about a plan, not code. Its value is catching design flaws *before* implementation. A skill that only reviews code is a code reviewer; a skill that reviews plans is an architect. This eval tests the distinction.
