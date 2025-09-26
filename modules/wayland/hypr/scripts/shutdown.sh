#!/usr/bin/env zsh

while true; do
  printf "Shutdown? (y/n): "
  read answer
  case "$answer" in
    [yY]) shutdown now ;;
    [nN]) echo "Cancelled." && sleep 0.7 && break ;;
    *)    echo "Invalid answer." && sleep 0.7 ;;
  esac
done

