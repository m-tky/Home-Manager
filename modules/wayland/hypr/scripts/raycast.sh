#!/usr/bin/env zsh
set -e

# === メニュー構築 ===
# Zshの配列はシンプルに書けます
options=(
  " Web Search"
  " Calculator"
  "⏻ System"
  "󰈙 Open File by filename"
  " Open File by Content"
  "󱓞 Launch App"
  "󰿅 Exit"
)

# Bashの `printf` ループの代わりに、Zsh特有の `print -l` (行ごとに表示) を使用
choice=$(print -l $options | fuzzel --dmenu --prompt "Menu:")

case "$choice" in
  *"Web Search"*)
    query=$(fuzzel --dmenu --prompt "Search the Web:")
    [[ -n "$query" ]] && xdg-open "https://www.google.com/search?q=${query}"
    ;;
  *"Calculator"*)
    expr=$(fuzzel --dmenu --prompt "Calc:")
    # 元コードの `]] then` のエラーを `]]; then` に修正
    if [[ -n "$expr" ]]; then
      # Pythonでの計算ロジックはそのまま維持
      result=$(python3 -c "import numpy as np; print(np.round(eval('$expr'), 3))" 2>/dev/null || echo "Error")
      notify-send "󰪚 Result" "$expr = $result"
    fi
    ;;
  *"Launch App"*)
    # 通常fuzzelは引数なしで起動するとランチャーになりますが、
    # dmenuモードで文字列を受け取ってgtk-launchする元のロジックを尊重しています
    selected=$(fuzzel --dmenu --prompt "App:") 
    [[ -n "$selected" ]] && gtk-launch "$selected"
    ;;
  *"System"*)
    sysopt=$(print -l \
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
    # findfile.sh も zsh に書き直している場合は拡張子に注意してください
    kitty --class "FindFile" $HOME/.local/bin/findfile.sh "$HOME"
    ;;
  *"Open File by Content"*)
    kitty --class "FindContent" $HOME/.local/bin/findcontent.sh "$HOME"
    ;;
  *"Exit"*)
    exit 0
    ;;
esac
