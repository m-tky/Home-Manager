#!/usr/bin/env bash
set -e

# === メニュー構築 ===
options=(
  " Web Search"
  " Calculator"
  "⏻ System"
  "󰈙 Open File by filename"
  " Open File by Content"
  "󱓞 Launch App"
  "󰿅 Exit"
)

choice=$(printf '%s\n' "${options[@]}" | fuzzel --dmenu --prompt "Menu:")

case "$choice" in
*"Web Search"*)
  query=$(fuzzel --dmenu --prompt "Search the Web:")
  [[ -n "$query" ]] && xdg-open "https://www.google.com/search?q=${query}"
  ;;
*"Calculator"*)
  expr=$(fuzzel --dmenu --prompt "Calc:")
  if [[ -n "$expr" ]] then
    result=$(python3 -c "import numpy as np; print(np.round(eval('$expr'), 3))" 2>/dev/null || echo "Error")
    notify-send "󰪚 Result" "$expr = $result"
  fi
  ;;
*"Launch App"*)
  selected=$(fuzzel --prompt "App:")
  [[ -n "$selected" ]] && gtk-launch "$selected"
  ;;
*"System"*)
  sysopt=$(printf '%s\n' \
    " Lock" \
    " Reboot" \
    "⏻ Poweroff" | fuzzel --dmenu --prompt "System:")
  case "$sysopt" in
  *Lock*) hyprlock ;;
  *Reboot*) systemctl reboot ;;
  *Poweroff*) systemctl poweroff ;;
  esac
  ;;
*"Open File by filename"*)
  kitty --class "FindFile" $HOME/.local/bin/findfile.sh "$HOME"
  ;;
*"Open File by Content"*)
  kitty --class "FindContent" $HOME/.local/bin/findcontent.sh "$HOME"
  ;;
*"Exit"*)
  exit 0
  ;;
esac
