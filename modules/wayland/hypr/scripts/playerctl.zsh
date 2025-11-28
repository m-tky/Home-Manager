#!/usr/bin/env zsh

# --- HTMLエスケープ関数 ---
escape_html() {
    local str="$1"
    str=${str//&/&amp;}
    str=${str//</&lt;}
    str=${str//>/&gt;}
    str=${str//\"/&quot;}
    str=${str//\'/&apos;}
    echo "$str"
}

# --- JSON出力関数 ---
print_status() {
    local player_status
    player_status=$(playerctl status 2>/dev/null)
    local icon=""
    local color=""
    local text_class=""

    # プレイヤーがない場合
    if [[ -z "$player_status" || "$player_status" == "No players found" ]]; then
        local text="<span color=\"#f38ba8\"> No player</span>"
        jq -n \
           --arg text "$text" \
           --arg tooltip "No active media player." \
           '{"text": $text, "tooltip": $tooltip}'
        return
    fi

    # メタデータ取得
    local metadata
    metadata=$(playerctl metadata --format '{
        "artist": "{{artist}}",
        "title": "{{title}}",
        "album": "{{album}}",
        "player": "{{playerName}}"
    }' 2>/dev/null)

    # playerctlが空を返した場合（jqが死なないようにガード）
    if [[ -z "$metadata" ]]; then
        local text="<span color=\"#a6adc8\"> Unknown</span>"
        jq -n \
           --arg text "$text" \
           --arg tooltip "No metadata available" \
           '{"text": $text, "tooltip": $tooltip}'
        return
    fi

    # --- jqを通す前にHTMLエスケープ ---
    local artist title album player
    artist=$(escape_html "$(echo "$metadata" | jq -r '.artist')")
    title=$(escape_html "$(echo "$metadata" | jq -r '.title')")
    album=$(escape_html "$(echo "$metadata" | jq -r '.album')")
    player=$(escape_html "$(echo "$metadata" | jq -r '.player')")

    # 状態に応じて色とアイコンを設定
    case "$player_status" in
        "Playing")
            icon=""
            color="#a6e3a1" # 緑
            ;;
        "Paused")
            icon=""
            color="#f9e2af" # 黄
            ;;
        *)
            icon=""
            color="#f38ba8" # 赤
            ;;
    esac

    local text="<span color=\"$color\">$icon</span> $artist - $title"

    # jqでJSON出力
    jq -n -c \
       --arg text "$text" \
       --arg title "$title" \
       --arg artist "$artist" \
       --arg album "$album" \
       --arg player "$player" \
       '
       {
           "text": $text,
           "tooltip": ("🎵 " + $title + "\n" +
                       "👤 " + $artist + "\n" +
                       "💿 " + $album + "\n" +
                       "📻 Player: " + $player)
       }'
}

# --- メインロジック ---

print_status

# playerctlイベント監視 + 定期更新
playerctl metadata status 2>/dev/null | while read -r line; do
    [[ -z "$line" ]] && continue
    print_status
done
