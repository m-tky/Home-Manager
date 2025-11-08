#!/usr/bin/env zsh

# --- ユーザー設定 ---

# ★1. rcloneのフルパス (ターミナルで `which rclone` して確認)
RCLONE_PATH="rclone"

# ★2. 同期したいローカルのフォルダ
LOCAL_DIR="/home/user/Documents/Obsidian/Documents" # (同期元はこれで合っていますか？)

# ★3. rcloneで設定したリモート名 (コロン不要)
REMOTE_NAME="mainwebdav"

# ★4. リモートのサブディレクトリ（新しい設定）
REMOTE_SUBDIR="Takuya/Documents/WorkDocs"

# ★5. サーバーのURL（疎通確認用。rclone configで設定したURLのベース）
SERVER_URL="http://webdav.home.arpa/"

# ★6. ログファイルのパス
LOG_FILE="/tmp/rclone_sync.log"

# ------------------

# サーバーが応答するかチェック (タイムアウト5秒)
if curl -L --head --fail -s --max-time 5 -u "user:03071109" "$SERVER_URL" >/dev/null; then
  # サーバーがオンラインなら、rcloneで同期を実行
  echo "$(date): Server online. Starting sync." >> "$LOG_FILE"

  # 宛先を $REMOTE_NAME:$REMOTE_SUBDIR に変更
  "$RCLONE_PATH" sync "$LOCAL_DIR" "$REMOTE_NAME:$REMOTE_SUBDIR" \
    --exclude ".*" \
    --exclude ".*/" \
    --log-file="$LOG_FILE"

else
  # サーバーがオフラインなら、ログに記録
  echo "$(date): Server offline. Skipping sync." >> "$LOG_FILE"
fi
