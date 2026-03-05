{
    osConfig,
    lib,
    ...
}: {
    config = lib.mkIf osConfig.hostSettings.desktop.hyprland.enable {
        services.hypridle = {
            enable = true;
            settings = {
                listener = [
                    {
                        timeout = 600; # 10 minutes with 5 minute grace period
                        on-timeout = "hyprlock --grace 300";
                    }
                ];
            };
        };
    };
}
