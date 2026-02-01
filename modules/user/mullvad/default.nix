{
    osConfig,
    lib,
    ...
}: {
    config = lib.mkIf osConfig.hostSettings.mullvad.enable {
        programs.mullvad-vpn = {
            enable = true;
            package = null;
            settings = {
                autoConnect = true;
                startMinimized = true;
            };
        };
    };
}
