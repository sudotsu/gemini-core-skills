#!/usr/bin/env bash
# Syncs skills to Claude Code's skills directory.
# Run this after any changes to the skills: ./sync-claude.sh

SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

cp -r "$REPO_DIR/backend-expert" "$SKILLS_DIR/"
cp -r "$REPO_DIR/frontend-expert" "$SKILLS_DIR/"
cp -r "$REPO_DIR/devops-sre" "$SKILLS_DIR/"
cp -r "$REPO_DIR/qa-testing" "$SKILLS_DIR/"
cp -r "$REPO_DIR/lead-architect" "$SKILLS_DIR/"

echo "Synced to $SKILLS_DIR"
