{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: let
    theme = import (./. + "../../../themes" + ("/" + config.hostSettings.stylix.theme));
in {
    options = {
        hostSettings = {
            stylix.enable = lib.mkEnableOption "Stylix";
            stylix.theme = lib.mkOption {
                description = "Theme for Stylix to apply";
                type = lib.types.enum (lib.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ../../themes)));
                default = "everforest-medium";
            };
        };
    };

    imports = [
        inputs.stylix.nixosModules.stylix
    ];

    config = lib.mkIf config.hostSettings.stylix.enable {
        stylix.enable = true;
        # stylix.autoEnable = false;
        stylix.polarity = theme.polarity;
        stylix.image = pkgs.fetchurl {
            url = theme.backgroundUrl;
            sha256 = theme.backgroundSha256;
        };
        stylix.base16Scheme = theme;
        stylix.fonts = {
            monospace = {
                name = "JetBrainsMono Nerd Font";
                package = pkgs.nerd-fonts.jetbrains-mono;
            };
            serif = {
                name = "Fira Sans";
                package = pkgs.fira-sans;
            };
            sansSerif = {
                name = "Fira Sans";
                package = pkgs.fira-sans;
            };
            emoji = {
                name = "Twitter Color Emoji";
                package = pkgs.twitter-color-emoji;
            };
        };

        # stylix.targets.console.enable = true;
    };
}
