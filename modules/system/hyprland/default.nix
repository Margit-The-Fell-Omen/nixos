{
    config,
    lib,
    ...
}: {
    options = {
        hostSettings = {
            hyprland.enable = lib.mkEnableOption "Hyprland (required to use it per-user as well)";
        };
    };

    config = lib.mkIf config.hostSettings.hyprland.enable {
        programs.hyprland = {
            enable = true;
            xwayland.enable = true;
        };

        # NOTE: doesn't seem to work ;(
        #
        # services.displayManager.ly = {
        #   enable = true;
        # };
    };
}
