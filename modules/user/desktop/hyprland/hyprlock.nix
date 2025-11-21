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
        programs.hyprlock = {
            enable = true;
            settings = {
                general = {
                    fail_timeout = 1000;
                };

                animations = {
                    enabled = true;

                    bezier = [
                        "easeOutQuint,0.23,1,0.32,1"
                        "easeInOutCubic,0.65,0.05,0.36,1"
                    ];

                    animation = [
                        "global,1,10,default"
                        "fadeIn,1,8,easeInOutCubic"
                        "fadeOut,1,8,easeOutQuint"
                        "fade,1,3.03,quick"
                    ];
                };

                background = {
                    monitor = "";
                    # NOTE: stylix actually puts itself here
                    # path = config.stylix.image;
                    # path = "screenshot";
                    blur_passes = 3;
                };

                label = [
                    {
                        text = "cmd[update:1000] echo -e \"$(LC_TIME=en_US.UTF-8 date +\"%A, %B %d\")\"";
                        font_size = 25;
                        font_family = "SF Pro Display Semibold";
                        position = "0, 30%";
                        halign = "center";
                        valign = "center";
                    }

                    {
                        text = "cmd[update:1000] echo \"<span>$(date +\"%H:%M\")</span>\"";
                        font_size = 120;
                        font_family = "SF Pro Display Bold";
                        position = "0, 20%";
                        halign = "center";
                        valign = "center";
                    }
                ];

                input-field = {
                    size = "280, 55";
                    outline_thickness = 2;
                    dots_size = 0.2;
                    dots_spacing = 0.2;
                    dots_center = true;
                    fail_text = "Invalid Password ;(";
                    fade_on_empty = false;
                    font_family = "SF Pro Display Bold";
                    placeholder_text = "Password :3";
                    hide_input = false;
                    position = "0, 0";
                    halign = "center";
                    valign = "center";
                };
            };
        };
    });
}
