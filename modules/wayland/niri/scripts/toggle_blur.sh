#!/usr/bin/env bash

# 現在のブラー設定値を取得 (例: enabled: 1 または 0)
# 'hyprctl getoption' で現在の設定値を取得します
CURRENT_BLUR=$(hyprctl getoption decoration:blur:enabled -j | jq -r '.int')

# 値を反転させて設定
if [ "$CURRENT_BLUR" -eq 1 ]; then
  # 現在ONならOFFにする (0)
  hyprctl keyword decoration:blur:enabled 0
  echo "Blur OFF"
else
  # 現在OFFならONにする (1)
  hyprctl keyword decoration:blur:enabled 1
  echo "Blur ON"
fi
