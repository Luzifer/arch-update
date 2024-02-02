#!/bin/bash
set -euo pipefail

DRYRUN=0
LOGLINES=()
REBOOT=0
REQ_REBOOT=(linux linux-firmware systemd)
RESSVC=0

COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_CYAN="\033[0;36m"
COLOR_YELLOW="\033[0;33m"
COLOR_PLAIN="\033[0m"

# Check we do have root access
if [ $(id -u) -ne 0 ]; then
  echo "Escalating to root..."
  exec sudo $0 "$@"
fi

# Load defaults from defaults file
[ -f /etc/default/arch_update ] && source /etc/default/arch_update

function checktool() { # ( command )
  which "$1" >/dev/null 2>&1 && return 0 || return 1
}

function error() { # ( message )
  local msg="$@"
  log "$msg" "${COLOR_RED}"
}

function feature() { # ( name, enabled )
  local v
  [ $2 -eq 1 ] && v="${COLOR_GREEN}enabled${COLOR_PLAIN}" || v="${COLOR_YELLOW}disabled${COLOR_PLAIN}"
  echo "$1 $v"
}

function inArray() { # ( keyOrValue, arrayKeysOrValues )
  local e
  for e in "${@:2}"; do
    [[ $e == "$1" ]] && return 0
  done
  return 1
}

function info() { # ( message )
  local msg="$@"
  log "$msg" "${COLOR_CYAN}"
}

function log() { # ( message, color )
  local s
  local color="${2:-${COLOR_PLAIN}}"
  s="[$(date)] $1"
  echo -e "${color}${s}${COLOR_PLAIN}" >&2
  LOGLINES+=("$(echo "$s" | sed -E "s/\\\033\[[^m]*m//g")")
}

function main() { # ( )
  log "Starting arch_update on $(hostname): $(feature "dry-run" $DRYRUN), $(feature "reboot" $REBOOT), $(feature "service-restart" $RESSVC)"

  checktool checkupdates || {
    error "Missing tool 'checkupdates': Need to install package pacman-contrib"
    exit 1
  }

  # Collect packages to be updated
  log "Collecting packages..."
  packages=($(checkupdates --nocolor | awk '{print $1}' || true))

  if [ ${#packages[@]} -eq 0 ]; then
    success "Nothing to do, exiting now."
    exit 0
  fi

  info "${#packages[@]} packages to update: ${packages[@]}"

  # Collect services to be restarted
  log "Collecting affected services..."
  services=()

  for package in "${packages[@]}"; do
    if (systemctl is-active "${package}.service" >/dev/null); then
      services+=("${package}.service")
    fi
  done

  if [ ${#services[@]} -gt 0 ]; then
    info "${#services[@]} services to restart: ${services[@]}"
  else
    info "No services need to be restarted"
  fi

  # Check whether system should be rebooted
  log "Checking whether reboot is adviced..."
  needs_reboot=()
  for pkg in "${REQ_REBOOT[@]}"; do
    if (inArray "${pkg}" "${packages[@]}"); then
      needs_reboot+=("${pkg}")
    fi
  done

  if [ ${#needs_reboot[@]} -gt 0 ]; then
    warn "Reboot is adviced for: ${needs_reboot[@]}"
  fi

  # Ensure dry-run is met
  [ ${DRYRUN} -eq 0 ] || {
    success "Dry-Run enabled, not taking action!"
    exit 1
  }

  # Execute sync of repos
  log "Syncing repos..."
  pacman -Syy --noconfirm

  # Update packages
  log "Upgrading packages..."
  pacman -S --noconfirm "${packages[@]}"

  # If enabled and required do a reboot
  if [ ${#needs_reboot[@]} -gt 0 ]; then
    if [ $REBOOT -eq 1 ]; then
      info "Reboot will be executed in 1 minute"
      shutdown -r +1 # Give the script enough time to finish and queue reboot
      info "Reboot scheduled, ending script now"
      exit 0 # Do not execute more of this script
    else
      warn "Reboot is strongly suggested but auto-reboot is disabled"
      date +%s >/tmp/arch_update_needs_reboot
    fi
  fi

  # Restart affected services
  if [ $RESSVC -eq 1 ]; then
    for svc in "${services[@]}"; do
      log "Restarting service ${svc}"
      systemctl restart "${svc}" || error "Restart of ${svc} failed and needs attention"
    done
  else
    warn "Not restarting services as requested"
  fi

  success "Everything finished"
}

function sendResult() { # ( )
  IFS=$'\n'
  echo "${LOGLINES[*]}" >>/var/log/arch_update.log
}

function success() { # ( message )
  local msg="$@"
  log "$msg" "${COLOR_GREEN}"
}

function warn() { # ( message )
  local msg="$@"
  log "$msg" "${COLOR_YELLOW}"
}

# Argument parsing
while getopts ":nrs" o; do
  case "${o}" in
  n)
    DRYRUN=1
    ;;
  r)
    REBOOT=1
    ;;
  s)
    RESSVC=1
    ;;
  *)
    echo "Usage: $0 [-nrs]" >&2
    echo "    -n  Dry-Run: Do nothing except looking for updates" >&2
    echo "    -r  Reboot: In case packages flagged for reboot are updated, reboot after update" >&2
    echo "    -s  Services Restart: Restart all systemd services matching updated package names" >&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

trap sendResult EXIT
main
