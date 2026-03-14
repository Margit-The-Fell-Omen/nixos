{
    osConfig,
    lib,
    pkgs,
    ...
}: {
    imports = [
        ./hypridle.nix
        ./hyprland.nix
        ./hyprlock.nix
        ./hyprsunset.nix
    ];

    config = lib.mkIf osConfig.hostSettings.desktop.hyprland.enable {
        xdg.portal = {
            # HACK: for some reason `lib.mkForce` is required here
            enable = lib.mkForce true;
            extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
            configPackages = [pkgs.hyprland];
            config.hyprland = {
                default = ["hyprland" "gtk"];
            };
        };

        services.hyprpaper.enable = true;

        home.sessionVariables =
            {
                NIXOS_OZONE_WL = 1;
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
                if osConfig.hostSettings.hardware.graphics.nvidia.enable
                then {
                    WLR_NO_HARDWARE_CURSORS = 1;
                    WLR_RENDERER = "vulkan";
                    GBM_BACKEND = "nvidia-drm";
                    LIBVA_DRIVER_NAME = "nvidia";
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                }
                else {}
            );
    };
}
