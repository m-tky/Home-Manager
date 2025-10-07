#!/usr/bin/env zsh
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

# ファイルが存在するか、またはタイムアウトするまでループ
while [ ! -f "$NOTE_PATH" ] && [ "$ELAPSED" -lt "$TIMEOUT" ]; do
  sleep "$INTERVAL"
  # ELAPSED変数を小数点以下も扱えるよう計算（例：BCコマンドを使用）
  # 多くの環境で利用可能な `awk` で計算
  ELAPSED=$(echo "$ELAPSED + $INTERVAL" | awk '{printf "%.1f", $1}')
done

# タイムアウトした場合のエラー処理
if [ ! -f "$NOTE_PATH" ]; then
  notify-send "Error: Timeout reached ($TIMEOUT seconds). Daily note was not created or found at $NOTE_PATH."
  # エラーが発生した場合は、weztermを起動せずに終了
  return 1
fi

# --- ステップ B: ファイルが存在するか確認し、Vimで開く ---

wezterm start --class note vim "$NOTE_PATH" \
  "+/## Pomodoro Log" \
  "+:noh" \
  "+normal! kO" \
  "+normal! o### $CURRENT_TIME" \
  "+normal! j" \
  "+startinsert"
