{
  wayland.windowManager.hyprland.settings = {
    # ワークスペースとモニターの割り当て
    workspace = [
      "1, monitor:DP-1"
      "2, monitor:DP-1"
      "3, monitor:DP-1"
      "4, monitor:DP-1"
      "5, monitor:DP-1"
      "6, monitor:HDMI-A-1"
      "7, monitor:HDMI-A-1"
      "8, monitor:HDMI-A-1"
      "9, monitor:HDMI-A-1"
      "10,monitor:DP-2"
    ];

    # モニターの物理的な設定
    monitor = [
      "DP-1, 1920x1080@60, 0x1080, 1"
      "DP-2, 1920x1080@60, 0x0, 1, transform, 2"
      "HDMI-A-1, 1920x1080@60, 1920x655, 1, transform, 3"
      "Virtual-1, 1920x1080@60, 0x0, 1"
    ];
  };
}
