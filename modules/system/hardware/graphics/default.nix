{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings.graphics.enable = lib.mkEnableOption "graphics support";
    };

    config = lib.mkIf config.hostSettings.graphics.enable {
        hardware = {
            graphics = {
                enable = true;
                enable32Bit = true;
            };
        };
    };
}
