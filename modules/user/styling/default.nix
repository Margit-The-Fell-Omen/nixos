{
    config,
    osConfig,
    lib,
    ...
}: {
    imports = [
        ./cursors.nix
        ./fonts.nix
        ./stylix.nix
    ];

    config = lib.mkIf osConfig.hostSettings.styling.enable {
        # TODO: see if this breaks things
        gtk.gtk4.theme = config.gtk.theme; # silence warning
    };
}
