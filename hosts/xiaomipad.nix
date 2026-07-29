{ ... }:
{
  # nix-on-droid は Termux の端末だけを使うため、デスクトップ機能を含めない。
  imports = [ ../profiles/nix-on-droid.nix ];

  systemd.user.startServices = false;
}
