#!/bin/bash
set -euo pipefail

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="${SSHD_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"

# Must run as root
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Run this script as root." >&2
  exit 1
fi

# Safety check: ensure at least one authorized_keys entry exists for root
# to avoid being locked out after disabling password auth
AUTH_KEYS="/root/.ssh/authorized_keys"
if [[ ! -f "$AUTH_KEYS" ]] || [[ ! -s "$AUTH_KEYS" ]]; then
  echo "ERROR: No SSH keys found in $AUTH_KEYS." >&2
  echo "Add your public key before disabling password authentication." >&2
  exit 1
fi

echo "Found $(grep -c 'ssh-' "$AUTH_KEYS" 2>/dev/null || echo 0) key(s) in $AUTH_KEYS — safe to proceed."

# Backup original config
cp "$SSHD_CONFIG" "$BACKUP"
echo "Backup saved to $BACKUP"

# Apply settings using sed — handles both commented and uncommented lines
apply_setting() {
  local key="$1"
  local value="$2"
  # Remove any existing (commented or not) lines for this key, then append
  sed -i "/^#*\s*${key}\s/d" "$SSHD_CONFIG"
  echo "${key} ${value}" >> "$SSHD_CONFIG"
}

apply_setting "PasswordAuthentication"     "no"
apply_setting "PermitEmptyPasswords"       "no"
apply_setting "PubkeyAuthentication"       "yes"
apply_setting "PermitRootLogin"            "prohibit-password"
apply_setting "KbdInteractiveAuthentication" "no"

echo "Settings applied."

# Validate config syntax
if ! sshd -t; then
  echo "ERROR: sshd config validation failed. Restoring backup." >&2
  cp "$BACKUP" "$SSHD_CONFIG"
  exit 1
fi

echo "Config validated."

# Reload sshd
systemctl reload sshd
echo "sshd reloaded."

# Confirm effective settings
echo ""
echo "Effective settings:"
sshd -T | grep -E "passwordauthentication|pubkeyauthentication|permitrootlogin|permitemptypasswords|kbdinteractiveauthentication"
