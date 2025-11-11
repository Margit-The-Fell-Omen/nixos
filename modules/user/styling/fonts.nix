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
            styling.font.defaultSerif = {
                name = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    description = "Default serif font to use";
                    default = ["Fira Sans"];
                };
                package = lib.mkPackageOption pkgs "serif font" {
                    default = ["fira-sans"];
                };
            };
            styling.font.defaultSansSerif = {
                name = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    description = "Default sans-serif font to use";
                    default = ["Fira Sans"];
                };
                package = lib.mkPackageOption pkgs "sans-serif font" {
                    default = ["fira-sans"];
                };
            };
            styling.font.defaultMonospace = {
                name = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    description = "Default monospace font to use";
                    default = ["JetBrainsMono Nerd Font"];
                };
                package = lib.mkPackageOption pkgs "monospace font" {
                    default = ["nerd-fonts" "jetbrains-mono"];
                };
            };
            styling.font.defaultEmoji = {
                name = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    description = "Default emoji font to use";
                    default = ["Twitter Color Emoji"];
                };
                package = lib.mkPackageOption pkgs "emoji font" {
                    default = ["twitter-color-emoji"];
                };
            };
        };
    };

    config = lib.mkIf config.userSettings.styling.enable {
        fonts.fontconfig = {
            enable = true;
            defaultFonts = {
                serif = config.userSettings.styling.font.defaultSerif.name;
                sansSerif = config.userSettings.styling.font.defaultSansSerif.name;
                monospace = config.userSettings.styling.font.defaultMonospace.name;
                emoji = config.userSettings.styling.font.defaultEmoji.name;
            };
        };

        home.packages = with pkgs; [
            config.userSettings.styling.font.defaultSerif.package
            config.userSettings.styling.font.defaultSansSerif.package
            config.userSettings.styling.font.defaultMonospace.package
            config.userSettings.styling.font.defaultEmoji.package
        ];
    };
}
