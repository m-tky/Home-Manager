{
  config,
  pkgs,
  hostName,
  ...
}:

let
  homeDir = config.home.homeDirectory;

  # 実ディレクトリを指す（Nixはここを管理せず、ただ「使う」だけ）
  repoPath = "${homeDir}/Code/openclaw";

in
{
  home.packages = [
    pkgs.nodejs
    pkgs.pnpm
  ];

  systemd.user.services.openclaw-node = {
    Unit = {
      Description = "OpenClaw Node Host Service on ${hostName}";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      # 直接実行
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '\
          export OPENCLAW_GATEWAY_TOKEN=$(${pkgs.coreutils}/bin/cat ${homeDir}/.secrets/openclaw-gateway-token); \
          exec ${pkgs.nodejs}/bin/node ${repoPath}/openclaw.mjs node run \
            --host 192.168.179.99 \
            --port 18789 \
            --display-name "Node-${hostName}"'
      '';

      Environment = [
        "OPENCLAW_GATEWAY_TOKEN_FILE=${homeDir}/.secrets/openclaw-gateway-token"
        "HOME=${homeDir}"
      ];

      Restart = "always";
      RestartSec = "10";
      WorkingDirectory = repoPath;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
