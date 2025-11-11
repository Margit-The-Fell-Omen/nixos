#!/usr/bin/env bash
set -euo pipefail

DEFAULT_FLAKE_PATH = "$HOME/dotfiles"
FLAKE_PATH="${1:-$DEFAULT_FLAKE_PATH}"

pushd "$FLAKE_PATH" >/dev/null
trap "popd >/dev/null" EXIT

echo "[*] Formatting with alejandra..."
alejandra .

echo "[*] Staging changes..."
git add -A

echo "[*] Switching system..."
sudo nixos-rebuild switch --flake "$FLAKE_PATH#$(hostname)"

echo "[*] Determining new generation..."
GENERATION=$(sudo nixos-rebuild list-generations | grep current | awk '{print $1}')

if [[ -z "$GENERATION" ]]; then
    echo "[!] Could not detect generation. Exiting..." >&2
    exit 1
fi

echo "[*] Committing..."
git commit -m "generation ${GEN}"

echo "[+] Done!"
