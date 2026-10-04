# Module layout

`home/<host>.nix` はホスト固有の compositor・ハードウェア・ローカルサービスだけを記述し、共通の利用形態は `profiles/` から import する。

- `profiles/desktop.nix`: 通常の Linux デスクトップ共通設定
- `profiles/wsl.nix`: WSL の開発環境
- `profiles/nix-on-droid.nix`: Termux 上の nix-on-droid 用、CLI 専用の軽量開発環境

- `common/`: GUI を前提としない、すべての Linux 環境で共有する CLI とシェル設定。`cli/development-tools.nix` は PC・WSL・nix-on-droid 共通の開発 CLI、`cli/tools.nix` は通常 Linux 専用の追加ツール、`cli/config.nix` は各ツールの設定、`cli/default.nix` はその両方を読み込む通常 Linux 向けの入口
- `development/`: エディタ、言語・クラウド開発向けの設定
- `desktop/`: ブラウザー、同期、デスクトップアプリケーション、CAD などの GUI 設定
- `localization/`: 入力メソッドと言語設定
- `theme/`: GTK、Qt、カーソルなどの見た目
- `wayland/`: Wayland 共通機能と、Hyprland/Niri ごとの compositor 設定
- `config/`: 上記モジュールから参照する設定ファイル・アセット

各 `home/<host>.nix` は、対象マシンに必要なカテゴリだけを import する。

## Thunar で SMB 共有に接続

NixOS 側で `services.gvfs.enable = true` を設定する。デスクトップ設定は
`smb://` リンクを Thunar に関連付け、既存の GUI アプリの MIME 関連付けは保持する。

Thunar で `Ctrl+L` を押し、`smb://サーバー名/共有名` を入力する。
Atlas の NAS は `smb://atlas/nas`。認証画面では Samba サーバー側のユーザー名と
パスワードを使用する。ネットワーク一覧に表示されなくても URL で直接接続できる。
