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
}
