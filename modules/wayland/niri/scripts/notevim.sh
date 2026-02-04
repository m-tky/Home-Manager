#!/usr/bin/env zsh
set -e
# ----------------------------------------------------
# 1. 環境に合わせてここを設定してください
OBSIDIAN_VAULT="Obsidian"
DAILY_NOTE_FOLDER="/home/user/Documents/Obsidian/02_Daily"
DATE_FORMAT="+%Y-%m-%d" # Obsidianのデイリーノートの形式に合わせる
# ----------------------------------------------------

TODAY_DATE=$(date "$DATE_FORMAT")
NOTE_PATH="$DAILY_NOTE_FOLDER/${TODAY_DATE}.md"
CURRENT_TIME=$(date +"%H:%M")

# --- ステップ A: Obsidianに作成/オープンを指示（テンプレート適用のため） ---
# デイリーノートを作成/開くURIを呼び出す
xdg-open "obsidian://daily?vault=${OBSIDIAN_VAULT}" >/dev/null 2>&1 &

# Obsidianがファイルを処理する時間を確保するため、少し待つ
#
TIMEOUT=5    # タイムアウト時間 (秒)
INTERVAL=0.2 # 確認間隔 (秒)
ELAPSED=0    # 経過時間

while [ ! -f "$NOTE_PATH" ] && awk "BEGIN{exit !($ELAPSED < $TIMEOUT)}"; do
  sleep "$INTERVAL"
  ELAPSED=$(awk "BEGIN{printf \"%.1f\", $ELAPSED + $INTERVAL}")
done

# タイムアウトした場合のエラー処理
if [ ! -f "$NOTE_PATH" ]; then
  notify-send "Error: Timeout reached ($TIMEOUT seconds). Daily note was not created or found at $NOTE_PATH."
  # エラーが発生した場合は、weztermを起動せずに終了
  return 1
fi

wezterm start --class note vim "$NOTE_PATH" \
  "+/## Pomodoro Log" \
  "+:noh" \
  "+normal! kO" \
  "+normal! o### $CURRENT_TIME" \
  "+normal! j" \
  "+startinsert"
