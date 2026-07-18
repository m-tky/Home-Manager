{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [ ./tools.nix ];

  programs = {
    rclone = {
      enable = true;
    };
    bat.enable = true;
    git = {
      enable = true;
      settings = {
        aliases = {
          lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
          l = "log --oneline --graph --decorate --all";
        };
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
        theme = {
          "241" = [ "#bf68d9" ];
          activeBorderColor = [
            "#8ebd6b"
            "bold"
          ];
          inactiveBorderColor = [ "#535965" ];
          searchingActiveBorderColor = [
            "#8ebd6b"
            "bold"
          ];
          optionsTextColor = [ "#4fa6ed" ];
          selectedLineBgColor = [ "#323641" ];
          cherryPickedCommitFgColor = [ "#4fa6ed" ];
          cherryPickedCommitBgColor = [ "#bf68d9" ];
          markedBaseCommitFgColor = [ "#4fa6ed" ];
          markedBaseCommitBgColor = [ "#e2b86b" ];
          unstagedChangesColor = [ "#e55561" ];
          defaultFgColor = [ "#a0a8b7" ];
        };
        gui.showIcons = true;
        git = {
          allBranchesLogCmds = [
            "git log --graph --color=always --abbrev-commit --pretty=format:'%C(#bf68d9)%h%Creset %C(#e2b86b)%d%Creset %C(#a0a8b7 bold)%s%Creset %C(#535965)- %an (%cr)%Creset' --"
          ];
          branchLogCmd = "git log --graph --color=always --abbrev-commit --pretty=format:'%C(#bf68d9)%h%Creset %C(#e2b86b)%d%Creset %C(#a0a8b7 bold)%s%Creset %C(#535965)- %an (%cr)%Creset' $branchName --";
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
      icons = "auto";
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
              url = "*";
              name = "*";
              run = "git";
              group = "git";
            }
            {
              url = "*";
              name = "*/";
              run = "git";
              group = "git";
            }
          ];
        };
      };
      initLua = ../../../assets/yazi/init.lua;
    };

    zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        theme = "nightfox";
        themes = {
          onedarkpro = {
            fg = "#abb2bf";
            bg = "#282c34";
            black = "#282c34";
            red = "#e06c75";
            green = "#98c379";
            yellow = "#e5c07b";
            blue = "#61afef";
            magenta = "#c678dd";
            cyan = "#56b6c2";
            white = "#abb2bf";
            orange = "#d19a66";
          };
          onedarkpro-darker = {
            fg = "#a0a8b7";
            bg = "#1f2329";
            black = "#1f2329";
            red = "#e55561";
            green = "#8ebd6b";
            yellow = "#e2b86b";
            blue = "#4fa6ed";
            magenta = "#bf68d9";
            cyan = "#48b0bd";
            white = "#a0a8b7";
            orange = "#cc9057";
          };
          nightfox = {
            bg = "#2b3b51";
            fg = "#cdcecf";
            red = "#c94f6d";
            green = "#81b29a";
            blue = "#719cd6";
            yellow = "#dbc074";
            magenta = "#9d79d6";
            orange = "#f4a261";
            cyan = "#63cdcf";
            black = "#29394f";
            white = "#aeafb0";
          };
        };
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
      autosuggestion.enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      history = {
        size = 1000;
        path = "${config.xdg.dataHome}/zsh/history";
        save = 1000;
      };
      # エイリアス
      shellAliases = {
        grep = "grep --color=auto";
        # ezaのエイリアス群
        ei = "eza -G --icons --git --group-directories-first --sort=type";
        ea = "eza -G -a --icons --git --group-directories-first --sort=type";
        ee = "eza -G -aahl --icons --git --group-directories-first --sort=type";
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
      ];

      # その他のカスタム設定
      initContent = ''
        hms() {
          local host=$(hostname | cut -d. -f1)
          home-manager switch --flake "/home/user/.config/home-manager/#$(whoami)@$host"
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

        # Reference the executable direcly zsh-patina
        eval "$(${
          inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default
        }/bin/zsh-patina activate)"
      '';
    };
  };
  home = {
    # file = {
    #   ".zsh/zsh-syntax-highlighting.zsh".source = ./config/zsh-syntax-highlighting.zsh;
    # };
    sessionVariables = {
      BROWSER = "firefox"; # zen-browserは別途インストールが必要
      EDITOR = "vim";
      TERMINAL = "kitty"; # footは別途インストールが必要
      TESSDATA_PREFIX = "${pkgs.tesseract}/share/tessdata";
      GDK_BACKEND = "wayland";
      CODEX_CLI_PATH = "${
        inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      }/bin/codex";
    };
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
  };

  # place lazygit configfile
  xdg.configFile = {
    "zsh-patina/nightfox.toml".source = ../../../assets/zsh-patina/nightfox.toml;
    "zsh-patina/config.toml".source = ../../../assets/zsh-patina/config.toml;
  };
}
