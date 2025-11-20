{
    config,
    lib,
    libM,
    pkgs,
    inputs,
    system,
    ...
}: let
    theme = config.hostSettings.styling.grub.theme;
    themePackage =
        if (theme == "stylix")
        then null
        else pkgs.callPackage ./themes/${theme}/theme-dni.nix {logo = "nixos";};

    customThemes = libM.collectDirs ./themes;
in {
    options = {
        hostSettings = {
            styling = {
                grub.theme = lib.mkOption {
                    type = lib.types.enum (["stylix"] ++ customThemes);
                    description = "Grub theme to use";
                    default = "stylix";
                };
            };
        };
    };

    config = lib.mkIf config.hostSettings.styling.enable {
        environment.systemPackages = lib.optionals (theme
            != "stylix") [
            themePackage
        ];

        boot.loader.grub = lib.mkIf (theme != "stylix") {
            theme = "${themePackage}/share/grub/themes/${theme}";
        };

        stylix.targets.grub.enable = theme == "stylix";
    };
}
