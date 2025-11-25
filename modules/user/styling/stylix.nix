{
    config,
    osConfig,
    lib,
    libM,
    pkgs,
    inputs,
    ...
}: let
    theme = import ./../../themes/${config.userSettings.styling.theme};

    toList = x:
        if builtins.isList x
        then x
        else [x];

    fontCfg = config.userSettings.styling.fonts;

    pick = f: builtins.head (toList f.name);
    pickPkg = f: builtins.head (toList f.package);
in {
    options = {
        userSettings = {
            styling.theme = lib.mkOption {
                description = "Theme to apply";
                type = lib.types.enum (libM.collectDirs ../../themes);
                default = osConfig.hostSettings.styling.theme;
            };
        };
    };

    # NOTE: is not needed due to stylix automatically importing itself into home-manager;
    # this can be disabled by `stylix.homeManagerIntegration.autoImport`
    #
    # imports = [
    # 	inputs.stylix.homeManagerModules.stylix
    # ];

    config = lib.mkIf config.userSettings.styling.enable {
        stylix.enable = true;
        stylix.polarity = theme.polarity;
        stylix.image =
            if lib.isPath theme.background
            then theme.background
            else
                pkgs.fetchurl {
                    url = theme.background;
                    hash = theme.backgroundHash;
                };
        stylix.base16Scheme = theme;
        stylix.fonts = {
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

        stylix.cursor = config.userSettings.styling.cursor;
    };
}
