{
    lib,
    config,
    ...
}: {
    options = {
        hostSettings = {
            hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth support";
        };
    };

    config = lib.mkIf config.hostSettings.hardware.bluetooth.enable {
        hardware.bluetooth.enable = true;
    };
}
