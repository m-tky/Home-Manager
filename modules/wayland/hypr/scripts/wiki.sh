#!/usr/bin/env zsh

# エラー通知関数
notify_error() {
    local error_message="$1"
    notify-send -u critical -t 5000 "Wikipedia検索エラー" "$error_message"
    exit 1
}

# クリップボードからテキストを取得し、前後の空白を除去
TERM_TO_LOOKUP=$(wl-paste -n | xargs) || notify_error "wl-paste の実行に失敗しました。wayland-utils がインストールされているか確認してください。"

# クリップボードが空の場合は何もしない
if [ -z "$TERM_TO_LOOKUP" ]; then
    notify_error "クリップボードが空です。検索する単語をコピーしてください。"
fi

# wiki-tui は自動で最適な記事を検索するはず
# -l ja は日本語版Wikipediaを指定
# bash -c '...': ターミナル内で実行するコマンド
# read -p "...": wiki-tui 終了後、Enterキーが押されるまでターミナルを閉じない
TERM_CMD="foot -a wiki_popup zsh -c 'wiki-tui -l ja \"$TERM_TO_LOOKUP\"; read -p \"Press Enter to close the window...\"'"

# hyprland でターミナルを起動
hyprctl exec "$TERM_CMD" &
if [ $? -ne 0 ]; then
    notify_error "ERROR: Failed to execute terminal command. Please check if 'foot' is installed and configured correctly."
fi

exit 0
