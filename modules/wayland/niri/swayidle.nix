{
  config,
  pkgs,
  lib,
  ...
}:

{
  # swayidle サービスの有効化
  services.swayidle = {
    enable = true;

    # niriなどのWayland環境でグラフィカルセッションに紐付ける
    systemdTarget = "graphical-session.target";

    # タイムアウト設定
    timeouts = [
      {
        timeout = 601;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
    ];

    # スリープ直前の動作
    events = [
      {
        event = "before-sleep";
        command = "hyprlock";
      }
    ];
  };
}
