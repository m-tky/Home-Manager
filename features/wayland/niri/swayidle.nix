{
  config,
  lib,
  ...
}:
let
  lockCommand = "${lib.getExe config.programs.noctalia.package} msg session lock";
  niri = lib.getExe config.programs.niri.package;
in
{
  # アイドル管理はswayidleに一本化する。
  programs.noctalia.settings.idle.behavior = {
    lock.enabled = false;
    screen-off.enabled = false;
  };

  services.swayidle = {
    enable = true;

    # niriなどのWayland環境でグラフィカルセッションに紐付ける
    systemdTargets = [ "graphical-session.target" ];

    # 5分でロック、6分で画面OFF。操作再開時は画面を点灯する。
    timeouts = [
      {
        timeout = 300;
        command = lockCommand;
      }
      {
        timeout = 360;
        command = "${niri} msg action power-off-monitors";
        resumeCommand = "${niri} msg action power-on-monitors";
      }
    ];

    events = {
      before-sleep = lockCommand;
      lock = lockCommand;
      after-resume = "${niri} msg action power-on-monitors";
    };
  };
}
