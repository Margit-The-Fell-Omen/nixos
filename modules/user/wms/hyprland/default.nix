{
    config,
    lib,
    libM,
    pkgs,
    osConfig,
    ...
} @ inputs: {
    options = {
        userSettings = {
            hyprland.enable = lib.mkEnableOption "Hyprland";
        };
    };

    config = libM.requireHostSettings osConfig {
        require = ["hyprland" "graphics"];
        message = "Hyprland must also be enable on the system level";
    } (lib.mkIf config.userSettings.hyprland.enable {
        # config = lib.mkIf config.userSettings.hyprland.enable ({
        xdg.portal = {
            # HACK: ? for some reason `lib.mkForce` is required here
            enable = lib.mkForce true;
            extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
            configPackages = [pkgs.hyprland];
            config.hyprland = {
                default = ["hyprland" "gtk"];
            };
        };

        home.packages = with pkgs; [
            wl-clipboard
            grim
            slurp
        ];

        services = {
            hyprpaper.enable = true;
            mako = {
                enable = true;
                settings = {
                    default-timeout = 5 * 1000;
                    anchor = "bottom-right";
                    outer-margin = "10,0";
                };
            };
        };

        programs.rofi = {
            enable = true;
        };
        home.file."${config.home.homeDirectory}/.config/rofi/launcher.rasi".source = ./launcher.rasi;

        home.sessionVariables =
            {
                # some compatibility?
                NIXOS_OZONE_WL = 1;
                XDG_CURRENT_DESKTOP = "Hyprland";
                XDG_SESSION_DESKTOP = "Hyprland";
                XDG_SESSION_TYPE = "wayland";
                QT_QPA_PLATFORM = "wayland;xcb";
                OZONE_PLATFORM = "wayland";
                ELECTRON_OZONE_PLATFORM_HINT = "wayland";
                QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
                QT_AUTO_SCREEN_SCALE_FACTOR = 1;
                MOZ_ENABLE_WAYLAND = 1;
                GTK_USE_PORTALS = 1;
            }
            // (
                if osConfig.hostSettings.graphics.nvidia.enable
                then {
                    WLR_NO_HARDWARE_CURSORS = 1;
                    WLR_RENDERER = "vulkan";
                    GBM_BACKEND = "nvidia-drm";
                    LIBVA_DRIVER_NAME = "nvidia";
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                }
                else {}
            );
    });
}
