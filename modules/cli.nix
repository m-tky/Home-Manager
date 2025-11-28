{ config, pkgs, ... }:

{
  # 両方のOSで使うパッケージ
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [ numpy ]))
    jq
    tree
    tesseract
    gemini-cli
    neofetch
    delta
    unzip
    python3Packages.jupytext
    imagemagick
  ];

  programs = {
    rclone = {
      enable = true;
    };
    bat.enable = true;
    git = {
      enable = true;
      settings = {
        core = {
          pager = "delta --side-by-side";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          navigate = true;
          light = false;
        };
      };
    };
    lazygit = {
      enable = true;
      settings = {
        gui.showIcons = true;
        git = {
          allBranchesLogCmds = [
            "git log --graph --color=always --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(#9399b2 reverse)%h%Creset %C(cyan)%ad%Creset %C(#f38ba8)%ae%Creset %C(yellow reverse)%d%Creset %n%C(white bold)%s%Creset%n' --"
          ];
          branchLogCmd = "git log --graph --color=always --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(#9399b2 reverse)%h%Creset %C(cyan)%ad%Creset %C(#f38ba8)%ae%Creset %C(yellow reverse)%d%Creset %n%C(white bold)%s%Creset%n' $branchName --";
          pagers = [
            {
              colorArg = "always";
              pager = "delta --dark --paging=never --side-by-side --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
            }
          ];
          log = {
            showWholeGraph = true;
          };
          disableMerging = false;
          disableRebasing = false;
        };
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    bottom.enable = true;
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
      settings = {
        pane_frames = false;
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    # Zshの設定 (両OS共通)
    direnv = {
      enableZshIntegration = true;
      enable = true;
      nix-direnv.enable = true;
    };
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
        jutty = "kitty --listen-on=unix:@\"$(date +%s%N)\" -o allow_remote_control=yes";
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

        if [[ "$TOGGLETERM_IS_ACTIVE" != "1" ]]; then
          bindkey -v
        fi

        # history-substring-searchのキーバインド
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
      '';
    };
  };
  home = {
    sessionVariables = {
      BROWSER = "firefox"; # zen-browserは別途インストールが必要
      EDITOR = "vim";
      TERMINAL = "kitty"; # footは別途インストールが必要
      TESSDATA_PREFIX = "${pkgs.tesseract}/share/tessdata";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
  };

  # place lazygit configfile
  # xdg.configFile = {
  # };
}
