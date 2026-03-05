{lib, ...}: {
    imports = [
        ./grub
        ./plymouth

        ./fonts.nix
        ./stylix.nix
    ];

    options = {
        hostSettings = {
            styling.enable = lib.mkEnableOption "styling";
        };
    };
}
