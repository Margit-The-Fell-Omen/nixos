{
    config,
    osConfig,
    lib,
    pkgs,
    inputs,
    ...
}: let
    theme = import (./. + "../../../themes" + ("/" + config.userSettings.styling.stylix.theme));
in {
    options = {
        userSettings = {
            styling.stylix.enable = lib.mkEnableOption "Stylix";
            styling.stylix.theme = lib.mkOption {
                description = "Theme for Stylix to apply";
                type = lib.types.enum (lib.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir ../../themes)));
                default = "everforest-medium";
            };
        };
    };

    # NOTE: is not needed due to stylix automatically importing itself into home-manager;
    # this can be disabled by `stylix.homeManagerIntegration.autoImport`
    # imports = [
    # 	inputs.stylix.homeManagerModules.stylix
    # ];

    config = lib.mkIf (config.userSettings.styling.enable && config.userSettings.styling.stylix.enable) {
        stylix.enable = true;
        # stylix.autoEnable = false;
        stylix.polarity = theme.polarity;
        stylix.image = pkgs.fetchurl {
            url = theme.backgroundUrl;
            sha256 = theme.backgroundSha256;
        };
        stylix.base16Scheme = theme;
        stylix.fonts = {
            serif = {
                name = lib.elemAt config.userSettings.styling.font.defaultSerif.name 0;
                package = config.userSettings.styling.font.defaultSerif.package;
            };
            sansSerif = {
                name = lib.elemAt config.userSettings.styling.font.defaultSansSerif.name 0;
                package = config.userSettings.styling.font.defaultSansSerif.package;
            };
            monospace = {
                name = lib.elemAt config.userSettings.styling.font.defaultMonospace.name 0;
                package = config.userSettings.styling.font.defaultMonospace.package;
            };
            emoji = {
                name = lib.elemAt config.userSettings.styling.font.defaultEmoji.name 0;
                package = config.userSettings.styling.font.defaultEmoji.package;
            };
        };

        stylix.cursor = config.userSettings.styling.cursor;
    };
}
