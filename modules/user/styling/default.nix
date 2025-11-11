{
    config,
    osConfig,
    lib,
    pkgs,
    inputs,
    ...
}: {
    options = {
        userSettings = {
            styling.enable = lib.mkEnableOption "styling";
        };
    };
}
