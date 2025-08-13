{ config, pkgs, ... }:

{
  # 両方のOSで使うパッケージ
  home.packages = with pkgs; [
    pure-prompt
    tree
    tesseract
    # tesseract.data.eng
    # tesseract.data.jpn
    # tesseract.data.jpn_vert
    # tesseract.data.ell
    # tesseract.data.tha
    gemini-cli
    neofetch
    delta
  ];

  programs = {
    bat.enable = true;
    lazygit = {
      enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    btop = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        vim_keys = true;
        graph_symbol = "braille";
        graph_symbol_cpu = "braille";
        graph_symbol_gpu = "default";
        graph_symbol_mem = "default";
        rounded_corners = false;
      };
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "auto";
      git = true;
    };
    fd = {
      enable = true;
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
      plugins = {
        git = pkgs.yaziPlugins.git;
        full-border = pkgs.yaziPlugins.full-border;
      };
      settings = {
        plugin = {
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
        };
      };
      initLua = ./config/yazi/init.lua;
    };
    zellij = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    # Zshの設定 (両OS共通)
    zsh = {
      enable = true;
      history = {
        size = 1000;
        path = "${config.xdg.dataHome}/zsh/history";
        save = 1000;
      };
      # エイリアス
      shellAliases = {
        grep = "grep --color=auto";
        # ezaのエイリアス群
        ei = "eza --icons --git --group-directories-first --sort=type";
        ea = "eza -a --icons --git --group-directories-first --sort=type";
        ee = "eza -aahl --icons --git --group-directories-first --sort=type";
        ls = "ei";
        la = "ea";
        ll = "ee";
        l = "clear && ls";
      };

      # zinitの代わりにHome Managerのプラグイン機能を使う
      plugins = [
        # zsh-users のプラグイン
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions;
        }
        {
          name = "zsh-history-substring-search";
          src = pkgs.zsh-history-substring-search;
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
        }
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
        }
      ];

      # その他のカスタム設定
      initContent = ''
        # compinstallによる設定 (多くはデフォルトですが明示的に記述)
        hms() {
          local host=$(hostname | cut -d. -f1)
          home-manager switch --flake "/home/user/hm#user@$host"
        }
        autoload -Uz compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} r:|[._-]=** r:|=**' 'l:|=* r:|=*'
        zstyle ':completion:*' menu select=1
        if [ -x /usr/bin/dircolors ]; then
            eval "$(dircolors -b)"
        fi
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        # zsh-newuser-installによる設定
        setopt autocd extendedglob nomatch notify
        unsetopt beep

        # yaziをcd機能付きで呼び出す関数
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }

        # history-substring-searchのキーバインド
        bindkey -v
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
      '';
    };
  };
  home = {
    sessionVariables = {
      BROWSER = "zen"; # zen-browserは別途インストールが必要
      EDITOR = "nvim";
      TERMINAL = "foot"; # footは別途インストールが必要
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
  };

  # place lazygit configfile
  xdg.configFile = {
    "lazygit/config.yml".source = ./config/lazygit/config.yml;
    "btop/themes/catppuccin_mocha.theme".source = ./config/btop/themes/catppuccin_mocha.theme;
    "zellij/config.kdl".source = ./config/zellij/config.kdl;
  };
  # PATHの追加
}
