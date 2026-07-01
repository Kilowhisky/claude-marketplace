#!/usr/bin/env bash
# Install one or all skills from this marketplace into ~/.claude/skills/

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "$0")/skills" && pwd)"
TARGET_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

usage() {
  echo "Usage: $0 [skill-name]"
  echo ""
  echo "  skill-name   Install a specific skill (e.g. ai-project-bootstrap)"
  echo "               Omit to install all skills"
  echo ""
  echo "Available skills:"
  for d in "$SKILLS_DIR"/*/; do
    echo "  - $(basename "$d")"
  done
}

install_skill() {
  local skill="$1"
  local src="$SKILLS_DIR/$skill"
  local dst="$TARGET_DIR/$skill"

  if [ ! -d "$src" ]; then
    echo "Error: skill '$skill' not found in $SKILLS_DIR" >&2
    exit 1
  fi

  mkdir -p "$dst"
  cp -r "$src/." "$dst/"
  echo "Installed: $skill -> $dst"
}

mkdir -p "$TARGET_DIR"

if [ $# -eq 0 ]; then
  for d in "$SKILLS_DIR"/*/; do
    install_skill "$(basename "$d")"
  done
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  usage
else
  install_skill "$1"
fi
