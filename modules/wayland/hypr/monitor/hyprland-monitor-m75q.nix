{
  wayland.windowManager.hyprland.settings = {
    # ワークスペースとモニターの割り当て
    workspace = [
      "1, monitor:DP-1"
      "2, monitor:DP-1"
      "3, monitor:DP-1"
      "4, monitor:DP-1"
      "5, monitor:DP-1"
      "6, monitor:DP-1"
      "7, monitor:DP-1"
      "8, monitor:DP-1"
      "9, monitor:DP-2"
      "10,monitor:DP-2"
    ];

    # モニターの物理的な設定
    monitor = [
      "DP-1, 3440x1440@120, 0x0, 1"
      "DP-2, 1920x1080@60, 760x1440, 1"
      # "HDMI-A-1, 1920x1080@60, 1920x655, 1, transform, 3"
      # "Virtual-1, 1920x1080@60, 0x0, 1"
    ];
  };
}
