{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            browsers.firefox.enable = lib.mkEnableOption "Firefox";
        };
    };

    config = lib.mkIf config.userSettings.browsers.firefox.enable {
        programs.firefox.enable = true;
    };
}
