#!/usr/bin/env zsh
echo "Running sudo nixos-rebuild switch --flake .#$(hostname)..."
sudo nixos-rebuild switch --flake .#$(hostname)

if [[ $? -ne 0 ]]; then
  exit 1;
fi

DIRS=$(ls -dtr /nix/var/nix/profiles/system*| cut -d" " -f1 | tail -n 3 | head -n 2)

OLDDIR=$(echo "$DIRS" | head -n 1)
NEWDIR=$(echo "$DIRS" | tail -n 1)

echo
echo "Comparing $NEWDIR and $OLDDIR"
nvd diff "$OLDDIR" "$NEWDIR"
