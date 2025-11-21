{
    config,
    osConfig,
    lib,
    libM,
    ...
}: {
    config = libM.requireHostSettings osConfig {
        require = ["hyprland" "graphics"];
        message = "Hyprland must also be enable on the system level";
    } (lib.mkIf config.userSettings.hyprland.enable {
        services.hypridle = {
            enable = true;
            settings = {
                listener = [
                    {
                        timeout = 300; # 5 minutes with 1 minute grace period
                        on-timeout = "hyprlock --grace 60";
                    }
                ];
            };
        };
    });
}
