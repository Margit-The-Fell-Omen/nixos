{
    config,
    lib,
    ...
}: {
    options = {
        hostSettings = {
            desktop.hyprland.enable = lib.mkEnableOption "Hyprland";
        };
    };

    config = lib.mkIf config.hostSettings.desktop.hyprland.enable {
        programs.hyprland.enable = true;
    };
}
