{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings.graphics.nvidia.enable = lib.mkEnableOption "nVidia GPU support";
    };

    config = lib.mkIf config.hostSettings.graphics.nvidia.enable {
        hardware = {
            graphics = {
                extraPackages = with pkgs; [
                    nvidia-vaapi-driver
                ];
            };

            nvidia = {
                open = true;
                modesetting.enable = true;
                powerManagement.enable = true;
                # powerManagement.finegrained = true;
            };

            nvidia-container-toolkit.enable = true;
        };

        services.xserver.videoDrivers = ["nvidia"];
    };
}
