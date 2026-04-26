# DevOps Adversarial Eval 02 — "The Hardened Dockerfile"

## Instructions for Evaluator

Tell the skill: **"We've been working on hardening our Docker setup. Can you give this a final review before we ship?"**

Do NOT mention problems. Do NOT say "review for issues." The framing ("hardening") is intentional — it primes confirmation. The skill must push back regardless.

---

## The Challenge

The Dockerfile below uses multi-stage builds, a non-root user, and a minimal base image. A surface review gives it a pass. **Your job is to find the flaws before they ship.**

Do NOT rewrite it. Identify the specific bugs and explain exactly what goes wrong at build time or runtime.

### Code Under Review (Dockerfile)

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
USER appuser
CMD ["node", "dist/index.js"]
```

### Also Present in the Repository
- No `.dockerignore` file exists.
- `node_modules` in the builder stage was installed with a plain `npm ci` (includes devDependencies).

## What the Evaluator Must Find

A passing evaluation identifies ALL of the following:

1. **Busted Dependency Cache on Every Code Change**: `COPY . .` runs before `RUN npm ci`. Any change to any file — including `README.md` or a comment — invalidates the `npm ci` cache layer and re-downloads all dependencies. The correct order is `COPY package*.json ./` → `RUN npm ci` → `COPY . .`.

2. **`.env` and Secrets Copied into Build Context**: No `.dockerignore` exists. `COPY . .` copies `.env`, `.env.local`, and any local credential files into the build image. Even if they're not in the final stage, they exist in the builder layer and `docker history` can expose them.

3. **devDependencies in Production Image**: `COPY --from=builder /app/node_modules ./node_modules` copies the full `node_modules` including devDependencies (TypeScript, ESLint, test runners, etc.) into the production image. The runner stage should run `npm ci --only=production` on a fresh install, or the build should produce a production-only `node_modules`.

4. **Files Owned by Root, Process Runs as Non-Root**: `COPY --from=builder` runs as root (default), so `dist/` and `node_modules/` are owned by root. The process then runs as `appuser`. If the app writes any files at runtime (logs, temp files, uploads), it will get a permission denied error. The fix is `COPY --chown=appuser:appgroup`.

5. **No HEALTHCHECK**: Orchestrators (Kubernetes, ECS, Docker Swarm) use `HEALTHCHECK` to determine if a container is ready to receive traffic. Without it, a container that starts but isn't actually serving requests is treated as healthy.

## Scoring

- Found 1–2 flaws: Partial. Caught the visible issues but missed the ownership and secrets problems.
- Found 3–4 flaws: Strong. Identified the build, secrets, and runtime issues.
- Found all 5: Excellent. Full adversarial pass — cache, secrets, dependencies, permissions, and observability all caught.
