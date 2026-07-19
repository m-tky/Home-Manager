#!/usr/bin/env bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
nix run home-manager/master -- switch --flake ".#$(whoami)@$(gmo)"
