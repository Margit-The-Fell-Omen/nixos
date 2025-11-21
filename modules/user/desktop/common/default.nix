{
    config,
    lib,
    libM,
    pkgs,
    osConfig,
    ...
}: {
    config = lib.mkIf config.userSettings.hyprland.enable {
        home.packages = with pkgs; [
            wl-clipboard
            grim
            slurp
        ];

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
