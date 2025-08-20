#!/bin/bash

# --- 設定 ---
OBSIDIAN_INBOX_DIR="$HOME/Documents/Obsidian/01_Inbox"
GEMINI_API_KEY="${GEMINI_API_KEY}" # 環境変数からAPIキーを読み込む
echo $GEMINI_APIKEY

# --- 事前チェック ---
if [ -z "$GEMINI_API_KEY" ]; then
    notify-send -u critical "Gemini要約エラー" "環境変数 GEMINI_API_KEY が設定されていません。"
    exit 1
fi

# 1. クリップボードからURLを取得
url=$(wl-paste -n | tr -d '[:space:]')

if [[ ! "$url" =~ ^https?:// ]]; then
    notify-send "クリップボードエラー" "有効なURLがクリップボードに見つかりません。"
    exit 1
fi

# 2. ウェブページのタイトルと現在の日時を取得
page_title=$(curl -sL "$url" | pup 'title text{}')
current_datetime_iso=$(date +"%Y-%m-%dT%H:%M:%S")
current_datetime_human=$(date +"%Y-%m-%d %H:%M")

if [ -z "$page_title" ]; then
    page_title="No Title"
    notify-send -u normal "タイトル取得" "ページのタイトルが取得できませんでした。"
fi

# -----------------------------------------------------------------------------
# ★ここからが変更の核心部分：Geminiへの詳細なプロンプト
# -----------------------------------------------------------------------------
# JSONに埋め込むために、プロンプト内の改行や特殊文字をエスケープする
# jqを使って安全にJSON文字列を生成するのが確実
prompt_text=$(cat << EOP
あなたは、ウェブページの情報を整理し、Obsidianに保存するためのMarkdownを生成する優秀なアシスタントです。
以下の指示と情報に基づいて、Markdownファイルを作成してください。

# 指示
- Frontmatterと本文を含む完全なMarkdownを生成してください。
- Frontmatterには、title, url, date, tags を含めてください。
- tagsには、内容を分析し、関連性が高いキーワードを3〜5個、YAMLのリスト形式で含めてください。'webclip'と'inbox'は必ず含めてください。
- 本文は、まずページのタイトルをH1見出し（#）として記述してください。
- 次に、「## 概要 (Gemini)」という見出しを作成し、その下にページ内容の要点を400字程度でまとめてください。
- **最重要:** 前置きや後書き、Markdownコードブロック（\`\`\`markdown ... \`\`\`）は絶対に含めず、--- から始まる生のMarkdownテキストだけを出力してください。

# 提供情報
- URL: ${url}
- Page Title: ${page_title}
- ISO Datetime for Frontmatter: ${current_datetime_iso}
- Human-readable Datetime for Body: ${current_datetime_human}
EOP
)

# Gemini APIにリクエストを送信
# `gemini-1.5-pro` を使うと、より複雑な指示への追従性が高まります
# flashでも十分機能します
json_payload=$(jq -n --arg prompt "$prompt_text" \
  '{ "contents": [ { "parts": [ { "text": $prompt } ] } ] }')

response=$(curl -s -H "Content-Type: application/json" \
    -d "$json_payload" \
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=${GEMINI_API_KEY}")

# エラーチェック
if echo "$response" | grep -q "error"; then
    error_message=$(echo "$response" | jq -r .error.message)
    notify-send -u critical "Gemini APIエラー" "$error_message"
    exit 1
fi

# APIレスポンスからMarkdownテキストを抽出
markdown_output=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')

if [ -z "$markdown_output" ] || [ "$markdown_output" == "null" ]; then
    notify-send -u critical "Gemini要約エラー" "Markdownの生成に失敗しました。"
    exit 1
fi

# ファイル名を作成し、Geminiの出力をそのまま保存
safe_title=$(echo "$page_title" | sed 's/[/\\?%*:|"<>]/_/g')
file_path="${OBSIDIAN_INBOX_DIR}/${safe_title}.md"

# Geminiが生成したMarkdownをそのままファイルに書き出す
echo -e "${markdown_output}" > "$file_path"

# 完了通知
notify-send "Obsidianに保存しました" "『${page_title}』をInboxに追加しました。"

exit 0
