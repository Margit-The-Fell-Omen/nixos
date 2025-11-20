{lib, ...}: {
    options = {
        hostSettings = {
            styling.enable = lib.mkEnableOption "styling";
        };
    };
}
