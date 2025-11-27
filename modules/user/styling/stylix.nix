{
    config,
    osConfig,
    lib,
    libM,
    pkgs,
    inputs,
    ...
}: let
    theme = import ./../../themes/${config.userSettings.styling.theme};

    toList = x:
        if builtins.isList x
        then x
        else [x];

    fontCfg = config.userSettings.styling.fonts;

    pick = f: builtins.head (toList f.name);
    pickPkg = f: builtins.head (toList f.package);
in {
    options = {
        userSettings = {
            styling.theme = lib.mkOption {
                description = "Theme to apply";
                type = lib.types.enum (libM.collectDirs ../../themes);
                default = osConfig.hostSettings.styling.theme;
            };
        };
    };

    # NOTE: is not needed due to stylix automatically importing itself into home-manager;
    # this can be disabled by `stylix.homeManagerIntegration.autoImport`
    #
    # imports = [
    # 	inputs.stylix.homeManagerModules.stylix
    # ];

    config = lib.mkIf config.userSettings.styling.enable {
        stylix.enable = true;
        stylix.polarity = theme.polarity;
        stylix.image =
            if lib.isPath theme.background
            then theme.background
            else
                pkgs.fetchurl {
                    url = theme.background;
                    hash = theme.backgroundHash;
                };

        stylix.targets.hyprpaper.enable = lib.mkForce (! (theme ? liveWallpaper));
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

        stylix.cursor = config.userSettings.styling.cursor;

        # Ensure the package is installed if a live wallpaper is selected
        home.packages = lib.mkIf (theme ? liveWallpaper) [
            pkgs.linux-wallpaperengine
        ];

        # Define the service manually to avoid "Option does not exist" errors
        systemd.user.services.linux-wallpaperengine = lib.mkIf (theme ? liveWallpaper) {
            Unit = {
                Description = "Wallpaper Engine for Linux";
                After = ["graphical-session-pre.target"];
                PartOf = ["graphical-session.target"];
            };
            Install = {
                WantedBy = ["graphical-session.target"];
            };
            Service = {
                # We manually point to the specific wallpaper folder
                ExecStart = ''
                    ${pkgs.linux-wallpaperengine}/bin/linux-wallpaperengine \
                        --silent \
                        --screen-root DP-1 \
                        --assets-dir %h/.local/share/Steam/steamapps/workshop/content/431960/${theme.liveWallpaper} \
                        %h/.local/share/Steam/steamapps/workshop/content/431960/${theme.liveWallpaper}
                '';
                Restart = "always";
            };
        };
    };
}
