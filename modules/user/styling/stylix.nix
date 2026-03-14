{
    config,
    osConfig,
    lib,
    pkgs,
    ...
}: let
    theme = import ./../../themes/${osConfig.hostSettings.styling.theme};

    fonts = osConfig.hostSettings.styling.fonts;
in {
    config = lib.mkIf osConfig.hostSettings.styling.enable {
        stylix = {
            enable = true;
            polarity = theme.polarity;
            image =
                if lib.isPath theme.background
                then theme.background
                else
                    pkgs.fetchurl {
                        url = theme.background;
                        hash = theme.backgroundHash;
                    };

            base16Scheme = theme;
            fonts = {
                serif = {
                    name = fonts.serif.name;
                    package = fonts.serif.package;
                };
                sansSerif = {
                    name = fonts.sansSerif.name;
                    package = fonts.sansSerif.package;
                };
                monospace = {
                    name = fonts.monospace.name;
                    package = fonts.monospace.package;
                };
                emoji = {
                    name = fonts.emoji.name;
                    package = fonts.emoji.package;
                };
            };

            cursor = config.userSettings.styling.cursor;
        };
    };
}
