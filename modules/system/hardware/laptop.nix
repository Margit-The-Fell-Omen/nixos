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
    };
}
