#!/usr/bin/env zsh

# Compatibility entry point for existing compositor bindings.
# Calculator: /calc, power/lock actions: /session.
# Web Search and Find File actions are indexed from desktop entries.
exec noctalia msg panel-toggle launcher
