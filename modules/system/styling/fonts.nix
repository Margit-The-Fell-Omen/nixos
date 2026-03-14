{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.hostSettings.styling.fonts;

    fontBlock = default: {
        name = lib.mkOption {
            type = lib.types.str;
            default = default.name;
            description = "Font name";
        };

        package = lib.mkOption {
            type = lib.types.package;
            default = default.package;
            description = "Package providing font";
        };
    };
in {
    options = {
        hostSettings = {
            styling.fonts = {
                serif = fontBlock {
                    name = "Fira Sans";
                    package = pkgs.fira-sans;
                };

                sansSerif = fontBlock {
                    name = "Fira Sans";
                    package = pkgs.fira-sans;
                };

                monospace = fontBlock {
                    name = "JetBrainsMono Nerd Font";
                    package = pkgs.nerd-fonts.jetbrains-mono;
                };

                emoji = fontBlock {
                    name = "Twitter Color Emoji";
                    package = pkgs.twitter-color-emoji;
                };
            };
        };
    };

    config = lib.mkIf config.hostSettings.styling.enable {
        fonts = {
            fontconfig = {
                enable = true;

                defaultFonts = {
                    serif = [cfg.serif.name];
                    sansSerif = [cfg.sansSerif.name];
                    monospace = [cfg.monospace.name];
                    emoji = [cfg.emoji.name];
                };
            };

            packages = [
                cfg.serif.package
                cfg.sansSerif.package
                cfg.monospace.package
                cfg.emoji.package

                pkgs.corefonts
            ];

            fontDir.enable = true;
        };
    };
}
