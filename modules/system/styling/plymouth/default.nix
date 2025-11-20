{
    config,
    lib,
    libM,
    pkgs,
    inputs,
    system,
    ...
}: let
    theme = config.hostSettings.styling.plymouth.theme;

    customThemes = libM.collectDirs ./themes;
    defaultThemes = libM.collectDirs "${pkgs.plymouth}/share/plymouth/themes";
in {
    options = {
        hostSettings = {
            styling = {
                plymouth.enable = lib.mkEnableOption "plymouth";
                plymouth.theme = lib.mkOption {
                    type = lib.types.enum (["stylix"] ++ customThemes ++ defaultThemes);
                    description = "Plymouth theme to use";
                    default = "stylix";
                };
            };
        };
    };

    config = lib.mkIf (config.hostSettings.styling.enable && config.hostSettings.styling.plymouth.enable) {
        boot = {
            # quiet boot
            initrd = {
                verbose = false;
            };

            kernelParams = [
                "quiet"
                "splash"
                "loglevel=3"
                "systemd.show_status=false"
                "udev.log_level=3"
                "udev.log_priority=3"
            ];

            plymouth = {
                inherit theme;

                enable = true;
                themePackages = lib.optionals (theme != "stylix") [
                    (pkgs.callPackage ./themes/${theme}/theme-dni.nix {})
                ];
            };
        };

        stylix.targets.plymouth.enable = theme == "stylix";
    };
}
