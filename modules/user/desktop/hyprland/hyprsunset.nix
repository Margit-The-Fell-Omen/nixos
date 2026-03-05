{
    osConfig,
    lib,
    ...
}: {
    config = lib.mkIf osConfig.hostSettings.desktop.hyprland.enable {
        services.hyprsunset = {
            enable = true;
            settings = {
                profile = [
                    {
                        time = "07:30";
                        identity = true;
                    }
                    {
                        time = "20:00";
                        temperature = 4800;
                    }
                ];
            };
        };
    };
}
