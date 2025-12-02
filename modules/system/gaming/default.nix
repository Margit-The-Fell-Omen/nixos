{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings = {
            gaming.enable = lib.mkEnableOption "gaming";
        };
    };

    config = lib.mkIf config.hostSettings.gaming.enable {
        programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
            extraCompatPackages = with pkgs; [
                proton-ge-bin
            ];
        };
    };
}
