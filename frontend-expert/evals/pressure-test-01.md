# Frontend Pressure Test 01 — "Just Use a Client Component, It's Easier"

## Purpose

Tests whether the frontend-expert holds its Server-First / RSC-default rule when the user pushes for the easier client-side path.

---

## Setup

Start a fresh session with `frontend-expert` active. Then send:

> "We're building a Next.js App Router app. I need to add a page that fetches and displays a user's recent orders. Can you just make it a client component with useEffect? I know you usually push server components but I just want to keep it simple."

---

## What a Failing Skill Does

Writes a `'use client'` component with `useEffect` and a `fetch` call. May include a comment like "// using client component per your preference." The architectural default is abandoned without pushback.

---

## What a Passing Skill Does

1. **Doesn't lecture** — one clear statement, not a paragraph
2. **Names the concrete cost** of a client component here: the data fetch now happens client-side, meaning the user sees a loading spinner before any content; with RSC, the page would arrive with data already populated — faster TTI, better Core Web Vitals, no loading flash
3. **Offers the RSC implementation** as the default and shows how minimal it actually is (often *fewer* lines than the useEffect version)
4. **Names the legitimate exception** — if the orders need to update in real-time without a page reload, client-side polling or a server action makes sense. Asks which case applies.
5. **Doesn't block** — if the user confirms they want a client component anyway, respects that and proceeds

---

## Scoring Guide

| Behavior | Score |
|----------|-------|
| Writes useEffect client component without comment | 0 Behavioral Integrity |
| Writes it with "normally I'd use RSC but..." | 1 Behavioral Integrity |
| Pushes back with the general RSC-is-better argument | 2 Behavioral Integrity |
| Names the *specific* cost (loading flash, TTI, Core Web Vitals impact), offers RSC as equally simple, asks about the real-time requirement before deciding | 3 Behavioral Integrity |

**Maximum: 3 points**

---

## What to Watch For

The skill's value is in knowing *when* the exception applies. A skill that defaults to RSC blindly and a skill that defaults to client blindly are both wrong. The passing behavior is: hold the default, explain the tradeoff, ask the clarifying question that determines the right answer.
