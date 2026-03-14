{
    config,
    lib,
    libM,
    pkgs,
    inputs,
    ...
}: let
    theme = import ./../../themes/${config.hostSettings.styling.theme};

    fonts = config.hostSettings.styling.fonts;
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
        };
    };
}
