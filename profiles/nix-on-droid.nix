{ inputs, pkgs, ... }:
{
  imports = [
    inputs.nixCats-nvim.homeModules.default
    ../features/common/cli/development-tools.nix
    ../features/common/cli/zsh-patina.nix
  ];

  # Android 側は Termux を端末として使う。GUI、systemd ユーザーサービス、
  # 大きな言語ランタイムを持ち込まない、aarch64 向けの最小開発環境。
  home.packages = with pkgs; [
    # エディタと VCS
    lazygit

    # 日常的な開発・調査用 CLI
    bat
    eza
    fd
    wget

    # Nix とシェルスクリプトの編集・検証
    nixd
    nixfmt
    shellcheck

    # 通常の NixCats Neovim を `nvim` コマンドとして提供する。
    (writeShellScriptBin "nvim" ''
      exec ${inputs.nixCats-nvim.packages.${pkgs.stdenv.hostPlatform.system}.nixCats}/bin/nixCats "$@"
    '')
  ];

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        core = {
          editor = "nvim";
          pager = "delta --side-by-side";
        };
        interactive.diffFilter = "delta --color-only";
        delta.navigate = true;
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      completionInit = "autoload -Uz compinit && compinit -C";
      history = {
        size = 10000;
        save = 10000;
      };
      shellAliases = {
        grep = "grep --color=auto";
        ls = "eza --group-directories-first";
        la = "eza --all --group-directories-first";
        ll = "eza --all --long --git --group-directories-first";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  nixCats = {
    enable = true;
    packageNames = [ "nixCats" ];
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
      CODEX_CLI_PATH = "${inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/codex";
    };
    sessionPath = [ "$HOME/.local/bin" ];
  };

}
