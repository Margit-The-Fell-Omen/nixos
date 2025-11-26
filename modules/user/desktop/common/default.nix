{
    config,
    lib,
    pkgs,
    ...
}: {
    config = lib.mkIf config.userSettings.hyprland.enable {
        home.packages = with pkgs; [
            wl-clipboard
            grim
            slurp
        ];

        programs.yazi.enable = true;

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
