{
    config,
    lib,
    pkgs,
    ...
}: {
    imports = [
        ./hardware-configuration.nix
    ];

    # here goes all additional hardware configuration you may need
}
