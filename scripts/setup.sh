#!/usr/bin/env bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix run home-manager/master -- switch --flake ".#$(whoami)@wsl"
