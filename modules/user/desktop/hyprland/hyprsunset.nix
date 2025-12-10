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
        services.hyprsunset = {
            enable = true;
            settings = {
                profile = [
                    {
                        time = "08:30";
                        identity = true;
                    }
                    {
                        time = "18:30";
                        temperature = 4800;
                    }
                ];
            };
        };
    });
}
