{
    config,
    osConfig,
    lib,
    pkgs,
    ...
}: let
    colors = config.lib.stylix.colors;
in {
    options = {
        userSettings = {
            misc.enable = lib.mkEnableOption "miscellaneous programs";
        };
    };

    config = lib.mkIf config.userSettings.misc.enable {
        programs = {
            btop = {
                enable = true;
                # needed for btop to show nVidia & AMD GPUs
                package = pkgs.btop.override {
                    cudaSupport = osConfig.hostSettings.graphics.nvidia.enable;
                    rocmSupport = true; # FIXME: for now let it be true forever
                };
                settings = {
                    theme_background = true;
                    truecolor = true;
                    vim_keys = true;
                    update_ms = 100;
                };
            };
            cava = {
                enable = true;
                settings = lib.mkIf osConfig.hostSettings.pipewire.enable {
                    input.method = "pipewire";
                    input.source = "auto";
                    color = {
                        gradient = 1;
                        gradient_count = 8;
                        gradient_color_1 = "'#${colors.base08}'";
                        gradient_color_2 = "'#${colors.base09}'";
                        gradient_color_3 = "'#${colors.base0A}'";
                        gradient_color_4 = "'#${colors.base0B}'";
                        gradient_color_5 = "'#${colors.base0C}'";
                        gradient_color_6 = "'#${colors.base0D}'";
                        gradient_color_7 = "'#${colors.base0E}'";
                        gradient_color_8 = "'#${colors.base06}'";
                    };
                };
            };
        };
    };
}
