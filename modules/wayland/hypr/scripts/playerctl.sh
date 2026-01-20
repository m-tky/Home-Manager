#!/usr/bin/env zsh

INTERVAL=1  # ← 実際は Waybar 側で管理するので使わなくてもOK

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

    # プレイヤーがない場合
    if [[ -z "$player_status" || "$player_status" == "No players found" ]]; then
        jq -n \
           --arg text "<span color=\"#f38ba8\"> No player</span>" \
           --arg tooltip "No active media player." \
           '{"text": $text, "tooltip": $tooltip}'
        return
    fi

    local metadata
    metadata=$(playerctl metadata --format '{
        "artist": "{{artist}}",
        "title": "{{title}}",
        "album": "{{album}}",
        "player": "{{playerName}}"
    }' 2>/dev/null)

    if [[ -z "$metadata" ]]; then
        jq -n \
           --arg text "<span color=\"#a6adc8\"> Unknown</span>" \
           --arg tooltip "No metadata available" \
           '{"text": $text, "tooltip": $tooltip}'
        return
    fi

    local artist title album player
    artist=$(escape_html "$(echo "$metadata" | jq -r '.artist')")
    title=$(escape_html "$(echo "$metadata" | jq -r '.title')")
    album=$(escape_html "$(echo "$metadata" | jq -r '.album')")
    player=$(escape_html "$(echo "$metadata" | jq -r '.player')")

    local icon color
    case "$player_status" in
        Playing)
            icon=""; color="#a6e3a1" ;;
        Paused)
            icon=""; color="#f9e2af" ;;
        *)
            icon=""; color="#f38ba8" ;;
    esac

    jq -n -c \
       --arg text "<span color=\"$color\">$icon</span> $artist - $title" \
       --arg title "$title" \
       --arg artist "$artist" \
       --arg album "$album" \
       --arg player "$player" \
       '{
           "text": $text,
           "tooltip": ("🎵 " + $title + "\n" +
                       "👤 " + $artist + "\n" +
                       "💿 " + $album + "\n" +
                       "📻 Player: " + $player)
       }'
}

print_status
