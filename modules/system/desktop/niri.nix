{
    config,
    lib,
    ...
}: {
    options = {
        hostSettings = {
            desktop.niri.enable = lib.mkEnableOption "Niri";
        };
    };

    config = lib.mkIf config.hostSettings.desktop.niri.enable {
        warnings = ["Niri support is not implemented yet."];
    };
}
