{
    config,
    lib,
    libM,
    pkgs,
    ...
}: let
    theme = config.hostSettings.styling.grub.theme;
    themePackage =
        if (theme == "stylix")
        then null
        else pkgs.callPackage ./themes/${theme}/theme.nix {};

    customThemes = libM.collectDirs ./themes;
in {
    options = {
        hostSettings = {
            styling.grub.theme = lib.mkOption {
                type = lib.types.enum (["stylix"] ++ customThemes);
                description = "Grub theme to use";
                default = "stylix";
            };
        };
    };

    config = lib.mkIf config.hostSettings.styling.enable {
        environment.systemPackages = lib.optional
        (theme != "stylix")
        themePackage;

        boot.loader.grub = lib.mkIf (theme != "stylix") {
            theme = "${themePackage}/share/grub/themes/${theme}";
        };

        stylix.targets.grub.enable = theme == "stylix";
    };
}
