{
    config,
    lib,
    pkgs,
    ...
}: {
    config = {
        # let home-manager manage itself
        programs.home-manager.enable = true;
    };
}
