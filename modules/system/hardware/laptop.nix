{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings.laptop.enable = lib.mkEnableOption "laptop support";
    };

    config = lib.mkIf config.hostSettings.laptop.enable {
        hardware.nvidia = {
            prime.offload = {
                enable = true;
                enableOffloadCmd = true;
            };

            powerManagement = {
                finegrained = true;
            };
        };

        # i think it's mostly useful on laptops only
        # and i don't think i need to move it into user-specific stuff
        # as it will be mostly required anyways if graphics is enabled
        environment.systemPackages = lib.optional config.hostSettings.graphics.enable pkgs.brightnessctl;
    };
}
