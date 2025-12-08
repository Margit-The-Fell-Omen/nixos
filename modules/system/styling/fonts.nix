{
    config,
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

    cfg = config.hostSettings.styling.fonts;
in {
    options = {
        hostSettings = {
            styling.fonts = {
                serif = fontBlock "serif" {
                    defaultName = "Fira Sans";
                    defaultPackage = pkgs.fira-sans;
                };

                sansSerif = fontBlock "sans-serif" {
                    defaultName = ["Fira Sans"];
                    defaultPackage = [pkgs.fira-sans];
                };

                monospace = fontBlock "monospace" {
                    defaultName = ["JetBrainsMono Nerd Font"];
                    defaultPackage = [pkgs.nerd-fonts.jetbrains-mono];
                };

                emoji = fontBlock "emoji" {
                    defaultName = ["Twitter Color Emoji"];
                    defaultPackage = [pkgs.twitter-color-emoji];
                };
            };
        };
    };

    config = lib.mkIf config.hostSettings.styling.enable {
        fonts.fontconfig = {
            enable = true;
            defaultFonts = {
                serif = toList cfg.serif.name;
                sansSerif = toList cfg.sansSerif.name;
                monospace = toList cfg.monospace.name;
                emoji = toList cfg.emoji.name;
            };
        };

        fonts.packages = lib.concatLists [
            (toList cfg.serif.package)
            (toList cfg.sansSerif.package)
            (toList cfg.monospace.package)
            (toList cfg.emoji.package)

            [pkgs.corefonts]
        ];
    };
}
