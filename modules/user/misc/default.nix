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
            bat.enable = true;
            eza.enable = true;
            cava = {
                enable = true;
                settings = {
                    input.method = "pipewire";
                    input.source = "auto";
                };
            };
        };

        home.packages = with pkgs; [
            fastfetch
            ripgrep
        ];
    };
}
