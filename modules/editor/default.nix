{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # nixCats-nvimが提供するhome-managerモジュールを読み込む
    inputs.nixCats-nvim.homeModules.default
  ];

  # `nixCats`パッケージとそれに付随する設定を有効化
  # flake.nixの `defaultPackageName = "nixCats";` に対応
  nixCats = {
    enable = true;
    # インストールしたいパッケージの名前を指定
    # あなたの `flake.nix` の `packageDefinitions` で定義されているものを指定します
    packageNames = [ "nixCats" ];
    # 他のモジュールオプションもここに追加できます
    # 例えば、特定のカテゴリを上書きしたり、別のパッケージ名を有効化したり
    # extraConfig = {
    #   categories = {
    #     go = true;
    #   };
    # };
  };
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-toolsai.jupyter
      ms-python.python
      mkhl.direnv
      asvetliakov.vscode-neovim
    ];

    profiles.default.userSettings = {
      # ★★★ここが修正点★★★
      # nixCatsモジュールがビルドした "nixCats" パッケージのパスを指定
      "vscode-neovim.neovimExecutablePaths.linux" = "${
        inputs.nixCats-nvim.packages.${pkgs.system}.nixCats
      }/bin/nixCats";
      # その他の推奨設定
      "vscode-neovim.useCtrlKeysForNormalMode" = true;
      "vscode-neovim.useCtrlKeysForVisualMode" = true;
      "telemetry.telemetryLevel" = "off";

      # font
      "editor.fontSize" = 14;
      "terminal.integrated.fontSize" = 14;
      "editor.fontFamily" = "Moralerspace Argon";
      "editor.fontLigatures" = true;
      "terminal.integrated.fontFamily" = "Moralerspace Argon";

      # --- 以前提案した快適設定 ---
      "workbench.list.smoothScrolling" = true;
      "workbench.tree.renderIndentGuides" = "always";
      "window.titleBarStyle" = "custom";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.smoothScrolling" = true;
      "editor.stickyScroll.enabled" = true;
      "editor.minimap.enabled" = false;

      # --- その他 ---
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "editor.renderWhitespace" = "boundary";

      # vscode-nvim
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };

      # settings for nix
      "python.experiments.enabled" = false;
      "python.terminal.activateEnvironment" = false;
      "python.venvFolders" = [ ];
    };
  };
}
