{
    config,
    osConfig,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            misc.enable = lib.mkEnableOption "miscellaneous programs";
        };
    };

    config = lib.mkIf config.userSettings.misc.enable {
        programs = {
            feh.enable = true;
            mpv.enable = true;

            btop = {
                enable = true;
                # needed for btop to show nVidia & AMD GPUs
                package = pkgs.btop.override {
                    cudaSupport = osConfig.hostSettings.graphics.nvidia.enable;
                    rocmSupport = osConfig.hostSettings.graphics.amd.enable;
                };
                settings = {
                    theme_background = true;
                    truecolor = true;
                    vim_keys = true;
                    update_ms = 100;
                };
            };
            lazydocker = lib.mkIf osConfig.hostSettings.docker.enable {
                enable = true;
            };
        };
    };
}
