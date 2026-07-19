#!/usr/bin/env bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
nix run home-manager/master -- switch --flake ".#$(whoami)@wsl"
