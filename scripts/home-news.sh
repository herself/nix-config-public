#!/bin/sh
echo "Running home-manager news --flake .#$(whoami)@$(hostname)..."
home-manager news --flake .#$(whoami)@$(hostname) --extra-experimental-features nix-command --extra-experimental-features flakes
