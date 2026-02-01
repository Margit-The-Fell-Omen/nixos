{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings = {
            mullvad.enable = lib.mkEnableOption "Mullvad";
        };
    };

    config = lib.mkIf config.hostSettings.mullvad.enable {
        services = {
            mullvad-vpn = {
                enable = true;
                package = pkgs.mullvad-vpn;
            };
        };
    };
}
