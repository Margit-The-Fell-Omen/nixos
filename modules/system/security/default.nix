{
    config,
    lib,
    ...
}: {
    options = {
        hostSettings = {
            security.enable = lib.mkEnableOption "security settings";
        };
    };

    config = lib.mkIf config.hostSettings.security.enable {
        security.sudo-rs = {
            enable = true;
            execWheelOnly = true;
        };
    };
}
