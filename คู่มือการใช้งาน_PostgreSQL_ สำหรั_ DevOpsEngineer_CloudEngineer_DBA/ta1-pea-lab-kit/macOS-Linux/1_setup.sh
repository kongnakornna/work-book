#!/bin/bash
# PEA Lab Kit setup for macOS / Linux (ta1) v8
SRC="$(cd "$(dirname "$0")/../lab-files" 2>/dev/null && pwd)"
D="$HOME/.ssh/pea-lab"
C="$HOME/.ssh/config"
pause() { echo; { read -r -p "Press Enter to close this window..." _ < /dev/tty; } 2>/dev/null || true; }
fail() { echo; echo "SETUP FAILED: $1"; echo "Please send a screenshot of this window to the instructor."; pause; exit 1; }
echo "==== PEA Lab Kit setup (ta1) v8 ===="
echo "Kit folder : $SRC"
echo "SSH folder : $HOME/.ssh"
[ -n "$SRC" ] && [ -f "$SRC/id_lab" ] || fail "lab-files/id_lab not found. Please extract the whole zip first."
echo "[1/4] Copy key and config ..."
mkdir -p "$D" || fail "cannot create $D"
cp "$SRC/id_lab" "$D/id_lab" && cp "$SRC/id_lab.pub" "$D/id_lab.pub" && cp "$SRC/config" "$D/config" || fail "copy failed"
cp "$SRC/known_hosts" "$D/known_hosts" || fail "copy known_hosts failed"
echo "[2/4] Fix permissions ..."
chmod 700 "$HOME/.ssh" "$D" && chmod 600 "$D/id_lab" "$D/config" "$D/known_hosts" && chmod 644 "$D/id_lab.pub" || fail "chmod failed"
echo "[3/4] Link ~/.ssh/config ..."
if [ -f "$C" ]; then
  if grep -qxF "Include pea-lab/config" "$C"; then
    echo "      already linked, skip"
  else
    cp -p "$C" "$C.bak" || fail "backup failed"
    { echo "Include pea-lab/config"; cat "$C.bak"; } > "$C.tmp" && mv "$C.tmp" "$C" || fail "cannot update $C"
    echo "      backup saved: $C.bak"
  fi
else
  echo "Include pea-lab/config" > "$C" || fail "cannot create $C"
  echo created > "$D/.created-config"
  echo "      new config created"
fi
chmod 600 "$C"
echo "[4/4] Verify ..."
if ssh -G lab-pg1 2>/dev/null | grep -q '^hostname ta1-pg1$'; then
  echo; echo "SUCCESS. Next: run 2_check.sh  or type:  ssh lab-pg1"
else
  fail "ssh does not see the PEA Lab config"
fi
pause
