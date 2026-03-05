{
    config,
    lib,
    ...
}: let
    cfg = config.userSettings.browsers;

    imports = lib.attrNames (lib.filterAttrs (name: value: (value != "directory") && (name != "default.nix")) (builtins.readDir ./.));
    browsers = map (lib.removeSuffix ".nix") imports;

    path =
        if (cfg.defaultBrowser != "none")
        then cfg.${cfg.defaultBrowser}.path
        else null;
in {
    imports = map (import_path: ./${import_path}) imports;

    options = {
        userSettings = {
            browsers.defaultBrowser = lib.mkOption {
                description = "Default browser to use";
                type = lib.types.enum (["none"] ++ browsers);
                default = "none";
            };
        };
    };

    # needed to avoid recursion
    config = lib.mkMerge (
        [
            (lib.mkIf (cfg.defaultBrowser != "none") {
                xdg.mimeApps.defaultApplications = lib.mkIf (path != null) {
                    "x-scheme-handler/http" = path;
                    "x-scheme-handler/https" = path;
                    "text/html" = path;
                    "application/pdf" = path;
                };

                home.sessionVariables = {
                    BROWSER = "${cfg.defaultBrowser}";
                };
            })
        ]
        ++ map (
            browser:
                lib.mkIf (cfg.defaultBrowser == browser) {
                    userSettings.browsers.${browser}.enable = true;
                }
        )
        browsers
    );
}
