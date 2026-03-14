{
    osConfig,
    lib,
    pkgs,
    ...
}: {
    imports = [
        ./rofi.nix
        ./waybar.nix
    ];

    config = lib.mkIf osConfig.hostSettings.desktop.enable {
        home.packages = with pkgs; [
            wl-clipboard
            grimblast
            satty
        ];

        programs.yazi = {
            enable = true;
            shellWrapperName = "y";
        };

        # my notification daemon of choice
        services = {
            mako = {
                enable = true;
                settings = {
                    default-timeout = 5 * 1000;
                    anchor = "bottom-right";
                    outer-margin = "10,0";
                };
            };
        };
    };
}
