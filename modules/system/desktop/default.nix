{
    config,
    lib,
    ...
}: let
    cfg = config.hostSettings.desktop;
in {
    options = {
        hostSettings = {
            desktop.enable = lib.mkOption {
                default = cfg.hyprland.enable || cfg.niri.enable;
                internal = true;
                visible = false;
                readOnly = true;
            };
        };
    };

    imports = [
        ./hyprland.nix
        ./niri.nix
    ];
}
