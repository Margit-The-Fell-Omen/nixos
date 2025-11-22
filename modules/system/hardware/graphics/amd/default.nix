{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings.graphics.amd.enable = lib.mkEnableOption "AMD GPU support";
    };

    config = lib.mkIf config.hostSettings.graphics.nvidia.enable {
        hardware = {
            amdgpu = {
                # NOTE: enable if encountering issues with default drivers
                # extraPackages = with pkgs; [
                #     amdvlk
                # ];
                # extraPackages32 = with pkgs; [
                #     driversi686Linux.amdvlk
                # ];

                # NOTE: enable if low resolution during initramfs stage
                # initrd.enable = true;

                opencl.enable = true;
            };

            nvidia-container-toolkit.enable = true;
        };

        services.xserver.videoDrivers = ["amdgpu"];
    };
}
