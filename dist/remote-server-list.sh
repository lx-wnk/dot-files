#!/usr/bin/env bash
# Seeded to ~/remote-server-list.sh by dotfiles-sync.sh, then sourced from ~/.zshrc.
# Private copy (chmod 600) — keep real hosts out of the repo. Add your servers below.

# connect <user> <host> [port=22]
connect() {
  local user="$1" host="$2" port="${3:-22}"
  ssh "$user@$host" -p "$port"
}

# One alias per server, e.g.:
# alias myServer="connect root 127.0.0.1 2222"
