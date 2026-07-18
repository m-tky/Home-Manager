#!/usr/bin/env zsh

# 一時ファイルのプレフィックス
TMP_PREFIX="ocr_output_"
# 一時ファイルのディレクトリ (オプション)
TMP_DIR="/tmp"

# wl-paste の内容を取得
# mimetype を確認するために -l オプションを使用
MIMETYPE=$(wl-paste -l)
CLEANED_TEXT=""

if [[ -z "$MIMETYPE" ]]; then
  notify-send "Translation" "Error: Clipboard is empty or wl-paste failed."
  exit 1
elif [[ "$MIMETYPE" == "text/"* ]]; then
  # テキストデータの場合
  # wl-paste から直接テキストを取得し、sedでスペースを削除
  CLEANED_TEXT=$(wl-paste)
elif [[ "$MIMETYPE" == "image/png" || "$MIMETYPE" == "image/jpeg" || "$MIMETYPE" == "image/jpg" ]]; then
  # 画像データの場合
  notify-send "Translate" "Processing image data from clipboard..."

  # 画像データを一時ファイルに保存
  IMAGE_TMPFILE=$(mktemp "$TMP_DIR/${TMP_PREFIX}XXXXXX.png")
  if ! wl-paste > "$IMAGE_TMPFILE"; then
    notify-send "Translation" "Failed to save image data to temporary file."
    exit 1
  fi

  if [[ -s "$IMAGE_TMPFILE" ]]; then
    # Tesseract で OCR 処理
    # 出力は標準出力に、日本語と英語を認識
    OCR_RAW_OUTPUT=$(tesseract --tessdata-dir "$TESSDATA_PREFIX" "$IMAGE_TMPFILE" stdout -l jpn+eng+tha+ell 2>/dev/null)

    if [[ -n "$OCR_RAW_OUTPUT" ]]; then

      # 日本語と隣接する半角スペースを削除 (日本語と半角スペースの前後を削除)
      CLEANED_TEXT=$(echo "$OCR_RAW_OUTPUT" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g; s/[[:space:]]+/ /g')

      # 日本語同士の間のスペースも削除
      CLEANED_TEXT=$(echo "$CLEANED_TEXT" | sed -E 's/([ぁ-んァ-ン一-龥]) ([[:space:]]+)/\1/g; s/([[:space:]]+) ([ぁ-んァ-ン一-龥])/\2/g')

      # 日本語と英語の間のスペースも削除
      CLEANED_TEXT=$(echo "$CLEANED_TEXT" | sed -E 's/([ぁ-んァ-ン一-龥]) ([ぁ-んァ-ン一-龥])/\1\2/g')

      # 英語と英語の間のスペースはそのままにする
      CLEANED_TEXT=$(echo "$CLEANED_TEXT" | sed -E 's/([ぁ-んァ-ン一-龥]) ([A-Za-z])/\1\2/g; s/([A-Za-z]) ([ぁ-んァ-ン一-龥])/\1\2/g')

    else
      notify-send "Translation" "OCR failed to recognize any text in the image."
    fi

    # 一時画像ファイルを削除
    rm "$IMAGE_TMPFILE"
  # else
  #   echo "エラー: 画像データの一時ファイルが空です。"
  fi
else
  notify-send "Translation" "Unsupported clipboard content type" "$MIMETYPE"
fi

FIFO_DIR="/tmp/lang_select_fifo_$$"
FIFO_PATH="$FIFO_DIR/selected_lang_fifo"

# 一時ディレクトリとFIFOをクリーンアップするためのトラップ設定
# スクリプトが終了する際に必ず実行されるようにする
cleanup() {
    echo "Cleaning up FIFO: $FIFO_PATH" > /dev/stderr # デバッグ用に標準エラー出力へ
    rm -f "$FIFO_PATH"
    rmdir "$FIFO_DIR" 2>/dev/null
}
trap cleanup EXIT # EXIT シグナルで cleanup 関数を実行

echo "--- Translation Main Script Started ---"
if [ -z "$CLEANED_TEXT" ]; then
    notify-send "Translation" "Clipboard is empty."
    exit 1
fi
mkdir -p "$FIFO_DIR" || { notify-send "Error" "Could not create temporary directory."; exit 1; }
mkfifo "$FIFO_PATH" || { notify-send "Error" "Could not create FIFO."; exit 1; }

echo "FIFO created at: $FIFO_PATH"
echo "Opening new terminal window for language selection..."

# 3. 別のkittyウィンドウを開き、言語選択スクリプトを実行
# select_language.sh に FIFO_PATH を引数として渡す
foot -a=select_language \
  zsh -c "select_language.sh \"$FIFO_PATH\"" &

# 4. メインスクリプトはFIFOからの言語入力を待機
echo "Waiting for language selection from the other terminal window..."
SELECTED_LANG=$(cat "$FIFO_PATH") # FIFOから読み込むまでブロックされる

if [ -z "$SELECTED_LANG" ]; then
    notify-send "Translation Cancelled" "No language selected."
    exit 0
fi

echo "--- Translation Main Script Received Language ---"
echo "Selected Language: $SELECTED_LANG"
LANGUAGE=""
case "$SELECTED_LANG" in
  "ja")
    LANGUAGE="Japanese "
    ;;
  "en")
    LANGUAGE="English -"
    ;;
  "th")
    LANGUAGE="Thai ----"
esac

translated_text=$(trans -brief -noconfirm -no-warn-empty :$SELECTED_LANG "$CLEANED_TEXT" 2>/dev/null)

# 翻訳失敗チェック
if [ $? -ne 0 ] || [ -z "$translated_text" ]; then
    notify-send "Translation Failed" "Could not translate text."
    exit 1
fi


# 不要な行を削除
# 出力全体から "-noconfirm" を削除する
translated_text=$(echo "$translated_text" | sed 's/-noconfirm//g')
# 最初の行に "-NoConfirm" がある場合も引き続き削除
translated_text=$(echo "$translated_text" | sed '1{/^ *\-NoConfirm/d;}')
translated_text=$(echo "$translated_text" | sed '1{/^ *\-Noconfirm/d;}')
translated_text=$(echo "$translated_text" | sed '1{/^ *\-noConfirm/d;}')
# 空白行を削除する（オプション）
translated_text=$(echo "$translated_text" | sed '/^$/d')
# 先頭と末尾の空白をトリムする（オプション）
translated_text=$(echo "$translated_text" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

echo "$translated_text" | wl-copy
# 整形テキスト
display_text="---------- Original ----------\n$CLEANED_TEXT\n\n---------- $LANGUAGE----------\n$translated_text"

# 一時ファイルに書き出し（改行や特殊文字を正確に保持）
temp_file=$(mktemp)
echo -e "$display_text" > "$temp_file"

# terminal起動（app-id指定、永続するためにcat）
foot -a=translation_kitty -e zsh -c "cat $temp_file; echo -e '\n\nPress Enter to close'; read"
