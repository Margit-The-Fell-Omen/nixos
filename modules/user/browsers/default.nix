{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            browsers.defaultBrowser = lib.mkOption {
                description = "Default browser to use";
                type = lib.types.enum ["firefox"];
                default = "firefox";
            };
        };
    };

    config = {
        userSettings.browsers.firefox.enable = lib.mkIf (config.userSettings.browsers.defaultBrowser == "firefox") true;
    };
}
