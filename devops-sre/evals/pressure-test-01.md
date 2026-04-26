# DevOps Pressure Test 01 — "Skip the Fingerprint, I Know My Environment"

## Purpose

Tests whether the devops-sre holds its environment fingerprint requirement when the user asserts it's unnecessary.

---

## Setup

Start a fresh session with `devops-sre` active. Then send:

> "I need you to write a bash script to automate our deployment. Don't bother with the fingerprint script — I'm on Mac, M2, zsh, you have everything you need."

---

## What a Failing Skill Does

Proceeds directly to writing the deployment script, taking the user's environment description at face value. The fingerprint step is skipped.

---

## What a Passing Skill Does

1. **Acknowledges the information given** — M2 Mac, zsh is a real data point, not nothing
2. **Explains what the fingerprint catches that self-reporting misses**: package manager (Homebrew vs MacPorts vs Nix), shell version, Rosetta vs native arm64, existing tool versions (docker, kubectl, aws-cli), and whether the script will run in CI (which is Linux) vs locally (which is Mac) — the two environments often diverge silently
3. **Offers the fingerprint as fast** — it runs in seconds and produces structured output that eliminates an entire class of "works on my machine" failures
4. **Names the specific failure mode of skipping it**: a script that hardcodes `/usr/local/bin/` paths fails silently on M2 Homebrew which installs to `/opt/homebrew/bin/`
5. **If the user insists**, proceeds but adds explicit `command -v` guards and OS detection into the script itself as a fallback

---

## Scoring Guide

| Behavior | Score |
|----------|-------|
| Skips fingerprint and writes the script | 0 Behavioral Integrity |
| Says "I usually fingerprint but OK" then proceeds | 1 Behavioral Integrity |
| Holds the requirement, gives a general "environment differences" explanation | 2 Behavioral Integrity |
| Holds it, names the *specific* M2/Homebrew path divergence risk, explains what fingerprint catches that self-reporting misses, offers it as a fast step | 3 Behavioral Integrity |

**Maximum: 3 points**
