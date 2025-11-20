{
    config,
    osConfig,
    lib,
    pkgs,
    inputs,
    ...
}: let
    toList = x:
        if builtins.isList x
        then x
        else [x];

    fontBlock = path: opt: {
        name = lib.mkOption {
            type = lib.types.oneOf [
                lib.types.str
                (lib.types.listOf lib.types.str)
            ];
            default = opt.defaultName;
            description = "Font name(s) for ${path}";
        };

        package = lib.mkOption {
            type = lib.types.oneOf [
                lib.types.package
                (lib.types.listOf lib.types.package)
            ];
            default = opt.defaultPackage;
            description = "Package(s) providing font(s) for ${path}";
        };
    };

    hostFonts = osConfig.hostSettings.styling.fonts;
in {
    options = {
        userSettings = {
            styling.fonts = {
                serif = fontBlock "serif" {
                    defaultName = hostFonts.serif.name;
                    defaultPackage = hostFonts.serif.package;
                };

                sansSerif = fontBlock "sans-serif" {
                    defaultName = hostFonts.sansSerif.name;
                    defaultPackage = hostFonts.sansSerif.package;
                };

                monospace = fontBlock "monospace" {
                    defaultName = hostFonts.monospace.name;
                    defaultPackage = hostFonts.monospace.package;
                };

                emoji = fontBlock "emoji" {
                    defaultName = hostFonts.emoji.name;
                    defaultPackage = hostFonts.emoji.package;
                };
            };
        };
    };

    config = lib.mkIf config.userSettings.styling.enable {
        fonts.fontconfig = {
            enable = true;
            defaultFonts = {
                serif = toList config.userSettings.styling.fonts.serif.name;
                sansSerif = toList config.userSettings.styling.fonts.sansSerif.name;
                monospace = toList config.userSettings.styling.fonts.monospace.name;
                emoji = toList config.userSettings.styling.fonts.emoji.name;
            };
        };

        home.packages = lib.concatLists [
            (toList
                config.userSettings.styling.fonts.serif.package)
            (toList
                config.userSettings.styling.fonts.sansSerif.package)
            (toList
                config.userSettings.styling.fonts.monospace.package)
            (toList
                config.userSettings.styling.fonts.emoji.package)
        ];
    };
}
