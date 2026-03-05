{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings = {
            mullvad.enable = lib.mkEnableOption "Mullvad VPN";
        };
    };

    config = lib.mkIf config.hostSettings.mullvad.enable {
        services.mullvad-vpn = {
            enable = true;
            # TODO: somehow does not exist in my nixpkgs? it does exist in unstable according to GitHub and search.nixos.org
            # but does not exist on 25.11
            #
            # enableEarlyBootBlocking = true;
            package = pkgs.mullvad-vpn;
        };
    };
}
