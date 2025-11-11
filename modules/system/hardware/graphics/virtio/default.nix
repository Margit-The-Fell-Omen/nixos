{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings.graphics.virtio.enable = lib.mkEnableOption "virtio support";
    };

    config = lib.mkIf config.hostSettings.graphics.virtio.enable {
        services.xserver.videoDrivers = ["virtio"];
    };
}
