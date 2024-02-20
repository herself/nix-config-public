#!/usr/bin/env zsh

echo "Running home-manager switch --flake .#$(whoami)@$(hostname)..."
home-manager switch --flake ".#$(whoami)@$(hostname)" --extra-experimental-features nix-command --extra-experimental-features flakes

if [[ $? -ne 0 ]]; then
  exit 1;
fi

DIRS=$(ls -dtr ~/.local/state/nix/profiles/home* | cut -d" " -f1 | tail -n 3 | head -n 2)

OLDDIR=$(echo "$DIRS" | head -n 1)
NEWDIR=$(echo "$DIRS" | tail -n 1)

echo
echo "Comparing $NEWDIR and $OLDDIR"
nvd diff "$OLDDIR" "$NEWDIR"
