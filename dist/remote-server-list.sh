#!/usr/bin/env bash
# Seeded to ~/remote-server-list.sh by dotfiles-sync.sh, then sourced from ~/.zshrc.
# Private copy (chmod 600) — keep real hosts out of the repo. Add your servers below.

# connect --user <user> --host <host> [--port <port>]
connect() {
  local user="" host="" port=22

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --user) user="$2"; shift 2 ;;
      --host) host="$2"; shift 2 ;;
      --port) port="$2"; shift 2 ;;
      *) echo "Unknown option: $1" >&2; return 1 ;;
    esac
  done

  if [[ -z "$user" || -z "$host" ]]; then
    echo "Usage: connect --user <user> --host <host> [--port <port>]" >&2
    return 1
  fi

  ssh "$user@$host" -p "$port"
}

# jump --user <user> --host <host> [--port <port>] --jump-host <jumpHost> [--jump-user <jumpUser>] [--jump-port <jumpPort>]
jump() {
  local user="" host="" port=22 jumpHost="" jumpUser="" jumpPort=22

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --user) user="$2"; shift 2 ;;
      --host) host="$2"; shift 2 ;;
      --port) port="$2"; shift 2 ;;
      --jump-host) jumpHost="$2"; shift 2 ;;
      --jump-user) jumpUser="$2"; shift 2 ;;
      --jump-port) jumpPort="$2"; shift 2 ;;
      *) echo "Unknown option: $1" >&2; return 1 ;;
    esac
  done

  if [[ -z "$user" || -z "$host" || -z "$jumpHost" ]]; then
    echo "Usage: jump --user <user> --host <host> [--port <port>] --jump-host <jumpHost> [--jump-user <jumpUser>] [--jump-port <jumpPort>]" >&2
    return 1
  fi

  ssh -J "$jumpUser@$jumpHost:$jumpPort" "$user@$host" -p "$port"
}

# One alias per server, e.g.:
# alias myServer="connect aw 1.2.3.4 2222"
# alias myFinalTarget="jump --user aw --host 5.6.7.8 --jump-user jumper --jump-host 1.2.3.4"