#!/usr/bin/env zsh

# ホスト名を取得
hostname=$(cat /etc/hostname)

# ホスト名が archdesk の場合
if [ "$hostname" = "m75q" ]; then
    # Hyprlandではワークスペースに移動し、その後にアプリを実行するのが一般的です。
    hyprctl dispatch exec foot --title specialfoot
    hyprctl dispatch exec obsidian

    hyprctl dispatch workspace 4
    hyprctl dispatch exec zen
    hyprctl dispatch workspace 1
    # hyprctl dispatch exec gtk-launch chrome-bbdeiblfgdokhlblpgeaokenkfknecgl-Default
    # hyprctl dispatch exec gtk-launch LINE--LINE--1748362244.746681
fi

# ホスト名が archmini の場合
if [ "$hostname" = "archmini" ]; then
    hyprctl dispatch workspace 1
    hyprctl dispatch exec foot
fi
