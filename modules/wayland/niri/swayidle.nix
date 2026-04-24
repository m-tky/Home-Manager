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

    # ここを修正：リスト [ { event = "..."; command = "..."; } ]
    # ではなく、アトリビュートセット { eventName = "command"; } に変更
    events = {
      before-sleep = "hyprlock";
      lock = "hyprlock"; # 必要であれば追加
    };
  };
}
