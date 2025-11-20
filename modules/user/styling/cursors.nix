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
            styling.cursor = {
                name = lib.mkOption {
                    type = lib.types.str;
                    description = "Cursor theme to use";
                    default =
                        if (config.stylix.polarity == "light")
                        then "Quintom_Ink"
                        else "Quintom_Snow";
                };
                package = lib.mkPackageOption pkgs "cursor" {
                    default = ["quintom-cursor-theme"];
                };
                size = lib.mkOption {
                    type = lib.types.int;
                    description = "Cursor size to use";
                    default = 24;
                };
            };
        };
    };

    config = lib.mkIf config.userSettings.styling.enable {
        gtk.cursorTheme = config.userSettings.styling.cursor;

        home.sessionVariables = {
            XCURSOR_THEME = config.userSettings.styling.cursor.name;
            XCURSOR_SIZE = config.userSettings.styling.cursor.size;
        };
    };
}
