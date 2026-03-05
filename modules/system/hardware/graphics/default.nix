{
    config,
    lib,
    ...
}: let
    cfg = config.hostSettings.hardware.graphics;
in {
    imports = [
        ./amd.nix
        ./nvidia.nix
        ./virtio.nix
    ];

    options = {
        hostSettings.hardware.graphics.enable = lib.mkOption {
            default = cfg.nvidia.enable || cfg.amd.enable || cfg.virtio.enable;
            internal = true;
            visible = false;
            readOnly = true;
        };
    };

    config = lib.mkIf cfg.enable {
        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };
    };
}
