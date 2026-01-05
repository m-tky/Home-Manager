#!/usr/bin/env zsh

while true; do
  printf "Shutdown? (y/n): "
  # -k 1: 1文字だけ読み取る（Enter不要）
  # -r: エスケープ文字を無視
  read -r -k 1 answer
  echo "" # 入力後に改行を入れる

  case "$answer" in
    [yY]) shutdown now ;;
    [nN]) echo "Cancelled." && sleep 0.7 && break ;;
    *)    echo "Invalid answer." && sleep 0.7 ;;
  esac
done
