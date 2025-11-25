{
    lib,
    config,
    ...
}: {
    options = {
        hostSettings = {
            bluetooth.enable = lib.mkEnableOption "Bluetooth";
        };
    };

    config = lib.mkIf config.hostSettings.bluetooth.enable {
        hardware.bluetooth = {
            enable = true;
        };
    };
}
