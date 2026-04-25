# DevOps Refactoring Challenge (Eval 01)

## The Challenge: The "Bloated Root" Dockerfile
Refactor this insecure, bloated Dockerfile into a **Hardened Multi-Stage** build.

### Bad Code (Dockerfile)
```dockerfile
FROM node:20
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```

## Success Criteria
1.  **Security**: Must NOT run as root (`USER appuser`).
2.  **Size**: Must use Multi-Stage builds (Build stage vs Runtime stage).
3.  **Hardening**: Use a minimal base image (Alpine/Distroless) for the final stage.
4.  **Hygiene**: Use a `.dockerignore` file.
