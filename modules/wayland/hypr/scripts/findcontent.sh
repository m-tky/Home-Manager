#!/usr/bin/env zsh

SEARCH_DIR="${1:-.}"
RG_PREFIX="rg --column --line-number --no-heading --smart-case"
INITIAL_QUERY=""
IFS=: read -rA selected < <(
  FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY") $SEARCH_DIR" \
    fzf --ansi \
    --color "hl:-1:underline,hl+:-1:underline:reverse" \
    --disabled --query "$INITIAL_QUERY" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} $SEARCH_DIR || true" \
    --prompt 'Find Content> ' \
    --delimiter : \
    --with-nth 1 \
    --keep-right \
    --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
    --layout=reverse \
    --preview-window 'right,70%,border-left,+{2}/3'
)
[ -n "${selected[0]}" ] && $EDITOR "${selected[0]}" "+${selected[1]}"
