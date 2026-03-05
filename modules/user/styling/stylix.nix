{
    config,
    osConfig,
    lib,
    pkgs,
    ...
}: let
    theme = import ./../../themes/${osConfig.hostSettings.styling.theme};

    fontCfg = osConfig.hostSettings.styling.fonts;

    toList = x:
        if builtins.isList x
        then x
        else [x];

    pick = f: builtins.head (toList f.name);
    pickPkg = f: builtins.head (toList f.package);
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
                    name = pick fontCfg.serif;
                    package = pickPkg fontCfg.serif;
                };
                sansSerif = {
                    name = pick fontCfg.sansSerif;
                    package = pickPkg fontCfg.sansSerif;
                };
                monospace = {
                    name = pick fontCfg.monospace;
                    package = pickPkg fontCfg.monospace;
                };
                emoji = {
                    name = pick fontCfg.emoji;
                    package = pickPkg fontCfg.emoji;
                };
            };
        };

        stylix.cursor = config.userSettings.styling.cursor;
    };
}
