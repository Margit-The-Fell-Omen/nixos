{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.userSettings.browsers;
    browsers = [
        "firefox"
        "brave"
    ];

    browserPackage =
        if cfg.defaultBrowser == "none"
        then null
        else pkgs."${cfg.defaultBrowser}";
    desktopFile =
        if browserPackage == null
        then null
        else
            builtins.head (builtins.filter (file: lib.hasSuffix ".desktop" file)
                (lib.attrNames (builtins.readDir "${browserPackage}/share/applications")));
in {
    options = {
        userSettings = {
            browsers.defaultBrowser = lib.mkOption {
                description = "Default browser to use";
                type = lib.types.enum (["none"] ++ browsers);
                default = "none";
            };
        };
    };

    config = lib.mkIf (cfg.defaultBrowser != "none") {
        userSettings.browsers = lib.genAttrs browsers (browser:
            lib.mkIf (cfg.defaultBrowser == browser) {
                enable = true;
            });

        xdg.mimeApps.defaultApplications = lib.mkIf (desktopFile != null) {
            "x-scheme-handler/http" = desktopFile;
            "x-scheme-handler/https" = desktopFile;
            "text/html" = desktopFile;
        };

        home.sessionVariables = lib.mkIf (cfg.defaultBrowser != "none") {
            BROWSER = "${cfg.defaultBrowser}";
        };
    };
}
