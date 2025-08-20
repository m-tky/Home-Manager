#!/usr/bin/env zsh

# 最初の引数としてFIFOのパスを受け取る
FIFO_PATH="$1"

if [ -z "$FIFO_PATH" ]; then
    echo "Error: FIFO path not provided." > /dev/stderr
    notify-send "Error" "FIFO path missing in select_language.sh"
    exit 1
fi

# 言語選択表示
echo "1) Japanese (ja)"
echo "2) English  (en)"
echo "3) Thai     (th)"

# zsh 互換の安全な入力
read -r "CHOICE?Enter number (Default=1): "

case "$CHOICE" in
    2) SELECTED_LANG="en" ;;
    3) SELECTED_LANG="th" ;;
    1|""|*) 
        if [ -n "$CHOICE" ] && [[ "$CHOICE" != 1 ]]; then
            echo "Invalid choice. Defaulting to Japanese (ja)." > /dev/stderr
        fi
        SELECTED_LANG="ja" ;;
esac

# FIFO に書き込む
echo "$SELECTED_LANG" > "$FIFO_PATH"
exit 0
