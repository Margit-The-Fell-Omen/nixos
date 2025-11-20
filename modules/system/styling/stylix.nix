{
    config,
    lib,
    libM,
    pkgs,
    inputs,
    ...
}: let
    theme = import ./../../themes/${config.hostSettings.styling.theme};

    toList = x:
        if builtins.isList x
        then x
        else [x];

    fontCfg = config.hostSettings.styling.fonts;

    pick = f: builtins.head (toList f.name);
    pickPkg = f: builtins.head (toList f.package);
in {
    options = {
        hostSettings = {
            styling = {
                theme = lib.mkOption {
                    description = "Theme to apply";
                    type = lib.types.enum (libM.collectDirs ../../themes);
                    default = "everforest-medium";
                };
            };
        };
    };

    imports = [
        inputs.stylix.nixosModules.stylix
    ];

    config = lib.mkIf config.hostSettings.styling.enable {
        stylix.enable = true;
        stylix.polarity = theme.polarity;
        stylix.image = pkgs.fetchurl {
            url = theme.backgroundUrl;
            sha256 = theme.backgroundSha256;
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
    };
}
