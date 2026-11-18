#!/bin/bash
# PEA Lab Kit uninstall for macOS / Linux (ta1) - restore your SSH settings
D="$HOME/.ssh/pea-lab"
C="$HOME/.ssh/config"
TS="$(date +%Y%m%d-%H%M%S)"
pause() { echo; { read -r -p "Press Enter to close this window..." _ < /dev/tty; } 2>/dev/null || true; }
to_trash() {  # move a file/folder to the Trash (macOS) or ~/.ssh/_trash (fallback)
  local src="$1" name; name="$(basename "$src")-$TS"
  if [ -d "$HOME/.Trash" ] && mv "$src" "$HOME/.Trash/$name" 2>/dev/null; then echo "      moved to Trash: $name"; return; fi
  mkdir -p "$HOME/.ssh/_trash" && mv "$src" "$HOME/.ssh/_trash/$name" && echo "      moved to ~/.ssh/_trash/$name"
}
echo "==== PEA Lab Kit uninstall (ta1) - restore your SSH settings ===="
echo "This will:"
echo "  - remove the line \"Include pea-lab/config\" from $C"
echo "  - move the folder $D to the Trash"
echo "Your own keys and other SSH settings are NOT touched."
{ read -r -p "Continue? [y/N] " ans < /dev/tty; } 2>/dev/null || read -r -p "Continue? [y/N] " ans || ans=""
case "$ans" in y|Y|yes|YES) ;; *) echo "Cancelled."; pause; exit 0 ;; esac
echo "[1/3] Remove PEA Lab line from config ..."
if [ -f "$C" ]; then
  grep -vxF "Include pea-lab/config" "$C" > "$C.peatmp"; cat "$C.peatmp" > "$C"; rm -f "$C.peatmp"
  echo "      done"
else
  echo "      no config file, skip"
fi
echo "[2/3] Tidy up ..."
if [ -f "$D/.created-config" ] && [ -f "$C" ] && [ ! -s "$C" ]; then
  echo "      config was created by the Kit and is now empty"; to_trash "$C"
fi
if [ -f "$C.bak" ]; then
  if [ -f "$C" ] && cmp -s "$C" "$C.bak"; then
    echo "      config is identical to config.bak"; to_trash "$C.bak"
  else
    echo "      config.bak kept (your config changed during the course): $C.bak"
  fi
fi
echo "[3/3] Move PEA Lab folder to Trash ..."
[ -d "$D" ] && to_trash "$D"
if ssh -G lab-pg1 2>/dev/null | grep -q '^hostname ta1-pg1$'; then
  echo "[WARN] ssh still sees PEA Lab config. Please send a screenshot to the instructor."
else
  echo; echo "UNINSTALL COMPLETE. Your SSH settings are back to normal."
fi
pause
