#!/usr/bin/env zsh

SEARCH_DIR="${1:-.}"
INITIAL_QUERY="${2:-}"

# rgでファイル名リストを生成するベースコマンド
RG_FILES_CMD="rg --files --hidden \
  --glob '!node_modules/' \
  --glob '!__pycache__/' \
  --glob '!venv/' \
  --glob '!.git/' \
  --glob '!.*/' \
  $SEARCH_DIR"

# fzfの{q}を使ってrgでファイルリストを絞り込むコマンド (モード1: rg検索)
# || true は検索結果が0件でもfzfがエラーにならないためのおまじない
RG_RELOAD_CMD="$RG_FILES_CMD | rg --smart-case --color=always {q} || true"

# fzf起動時の初期コマンド（初期クエリがある場合）
# 起動時は常にrg検索モードで開始します
INITIAL_COMMAND="$RG_FILES_CMD | rg --smart-case --color=always $(printf %q "$INITIAL_QUERY") || true"

file=$(
  FZF_DEFAULT_COMMAND="$INITIAL_COMMAND" \
    fzf --ansi \
    --layout=reverse \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --disabled --query "$INITIAL_QUERY" \
    --bind "change:reload:sleep 0.1; $RG_RELOAD_CMD" \
    --prompt 'Find File> ' \
    --keep-right \
    --preview 'bat --style=numbers --color=always --line-range :100 {} 2>/dev/null' \
    --preview-window 'right,70%,border-left'
)

# 選択されたファイルがあれば$EDITORで開く
[ -n "$file" ] && xdg-open "$file"
