{
    config,
    lib,
    ...
}: {
    options = {
        hostSettings = {
            hardware.graphics.virtio.enable = lib.mkEnableOption "virtio support";
        };
    };

    config = lib.mkIf config.hostSettings.hardware.graphics.virtio.enable {
        services.xserver.videoDrivers = ["virtio"];
    };
}
