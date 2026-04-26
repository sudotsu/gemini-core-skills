#!/usr/bin/env bash
echo "=== System Fingerprint ==="
echo "OS: $(uname -a)"
if [ -f /etc/os-release ]; then
    grep "PRETTY_NAME" /etc/os-release
fi
echo "Shell: $SHELL"
echo "--- Tools ---"
command -v node >/dev/null && node -v || echo "node: not found"
command -v bun >/dev/null && bun -v || echo "bun: not found"
command -v npm >/dev/null && npm -v || echo "npm: not found"
command -v docker >/dev/null && docker -v || echo "docker: not found"
command -v git >/dev/null && git --version || echo "git: not found"
echo "--- Package Managers ---"
command -v apt >/dev/null && echo "apt: available"
command -v brew >/dev/null && echo "brew: available"
echo "=========================="
