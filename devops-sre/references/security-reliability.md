# DevOps Security & Reliability Standards

## 1. Hardened Containers (Docker)
**The Goal**: Zero-root, minimal-footprint, and secure builds.
- **Non-Root User**: Every Dockerfile MUST create a system user and switch to it (`USER appuser`). NEVER run as root.
- **Multi-Stage Builds**: Use multi-stage builds to ensure the production image contains ONLY the runtime and compiled binaries, not build tools or source code.
- **Base Images**: Prefer minimal base images like `alpine` or `distroless`.
- **.dockerignore**: Always create a `.dockerignore` file to exclude `.git`, `.env`, `node_modules`, and local logs.

## 2. Zero-Secret Policy
**The Goal**: Prevent credentials from ever touching the codebase or image layers.
- **Environment Variables**: Use `ENV` only for non-sensitive config. Sensitive data must be passed via runtime secrets or volume mounts.
- **CI/CD Secrets**: Use GitHub Secrets or GitLab CI variables. NEVER hardcode them in YAML files.
- **Scanning**: Proactively suggest adding a secret-scanning tool (e.g., `gitleaks` or `trufflehog`) to the pipeline.

## 3. Infrastructure as Code (IaC) Integrity
- **Remote State**: Terraform MUST use a remote backend (S3/GCS/Azure Blob) with state locking (DynamoDB).
- **Verify-Before-Apply**: Always run `terraform plan` or `kubectl diff` and analyze the output before proposing a change.
- **Least Privilege**: IAM roles and Service Accounts must be scoped to the minimum permissions required for the task.

## 4. CI/CD Performance & Safety
- **Caching**: Implement layer caching for Docker builds and dependency caching (npm/pip/cargo) in CI pipelines.
- **Security Linting**: Integrate `hadolint` (Docker) and `tfsec` or `checkov` (IaC) into the CI flow.
- **Rollback Strategy**: Every deployment pipeline must include an automated or "one-button" rollback mechanism.
