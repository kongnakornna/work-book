#!/bin/bash
# PEA Lab connectivity check for macOS / Linux (ta1) v8
SRC="$(cd "$(dirname "$0")" && pwd)"
L="$SRC/check-result.txt"
K="$HOME/.ssh/pea-lab"
B="pea-bastion1"
pause() { echo; { read -r -p "Press Enter to close this window..." _ < /dev/tty; } 2>/dev/null || true; }
if [ ! -f "$K/id_lab" ]; then echo "[STOP] Setup has not been completed. Please run 1_setup.sh first."; pause; exit 1; fi
# Ask the Bastion to open host:port. Connection refused = allowed but nothing listens yet (normal before the lab installs it).
port_check() {
  local t="$1" out
  if out=$(ssh -o BatchMode=yes -o LogLevel=VERBOSE -W "$t" "$B" < /dev/null 2>&1 > /dev/null); then echo "$t OK"
  elif echo "$out" | grep -qi "refused"; then echo "$t OK (allowed, service not running yet)"
  elif echo "$out" | grep -qi "prohibited"; then echo "$t BLOCKED by Bastion"
  else echo "$t FAILED: $(echo "$out" | grep -iE "open failed|forwarding failed|denied|timed out|resolve" | tr '\n' ' ')"; fi
}
{
echo "==== PEA Lab connectivity check (ta1) v8 - $(uname -sr) ===="
echo "[1] OpenSSH version"; ssh -V 2>&1
echo "[2] TCP 22 to Bastion 1 and 2 (expected: OPEN OPEN)"
for ip in 146.190.6.43 159.89.209.96; do
  if nc -z -G 5 "$ip" 22 2>/dev/null || nc -z -w 5 "$ip" 22 2>/dev/null; then echo "$ip:22 OPEN"; else echo "$ip:22 BLOCKED"; fi
done
echo "[3] lab-pg1 / lab-pg2 / lab-infra (default path, expected: OK ...)"
ssh -o BatchMode=yes lab-pg1 'echo OK $(hostname) $(whoami) sudo=$(sudo -n true 2>/dev/null && echo yes || echo no)' 2>&1
ssh -o BatchMode=yes lab-pg2 'echo OK $(hostname)' 2>&1
ssh -o BatchMode=yes lab-infra 'echo OK $(hostname)' 2>&1
echo "[4] alt-pg1 (backup path, expected: OK ...)"
ssh -o BatchMode=yes alt-pg1 'echo OK $(hostname)' 2>&1
echo "[5] Shell on Bastion must be refused (expected: This account is currently not available)"
ssh -o BatchMode=yes "$B" 'echo SHOULD-NOT-PRINT' 2>&1
echo "[6] Jump to a VM not in your list must fail (expected: stdio forwarding failed)"
ssh -o BatchMode=yes -W 10.104.0.2:22 "$B" < /dev/null 2>&1
echo "[7] Ports for pgAdmin and ssh lab-tunnel (expected: OK on every line, never BLOCKED)"
for t in ta1-pg1:5432 ta1-pg2:5432 ta1-infra:6432 ta1-infra:5000 ta1-infra:5001 ta1-infra:3000 ta1-infra:9090 ta1-infra:8025; do port_check "$t"; done
echo "==== done ===="
} 2>&1 | tee "$L"
echo; echo "Result saved to: $L"
[ "$(uname)" = "Darwin" ] && open -e "$L" 2>/dev/null
pause
