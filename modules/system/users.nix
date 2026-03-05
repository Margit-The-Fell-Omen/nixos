{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings = {
            users = lib.mkOption {
                description = "List of users to create on the host";
                type = lib.types.listOf lib.types.attrs;
            };
        };
    };

    config = {
        users.users = lib.listToAttrs (map (user: {
            name = user.name;

            value = {
                isNormalUser = true;

                extraGroups =
                    ["networkmanager"]
                    ++ (lib.optional (
                        if user ? isAdmin
                        then user.isAdmin
                        else false
                    ) "wheel")
                    ++ (lib.optional config.hostSettings.kernel.tty0tty.enable "dialout")
                    ++ (lib.optional config.hostSettings.gaming.enable "gamemode")
                    ++ (lib.optional config.hostSettings.virtualization.docker.enable "docker")
                    ++ (lib.optional config.hostSettings.virtualization.libvirt.enable "libvirtd");

                createHome = true;

                shell =
                    if user ? shell
                    then user.shell
                    else pkgs.zsh;
            };
        })
        config.hostSettings.users);

        home-manager.users = lib.listToAttrs (map (user: {
            name = user.name;
            value = {
                home = {
                    username = user.name;
                    homeDirectory = "/home/${user.name}";
                };
            };
        })
        config.hostSettings.users);

        # enable zsh if necessary
        programs.zsh = let
            zshUsed = builtins.any (user: (! (user ? shell) || user.shell == pkgs.zsh)) config.hostSettings.users;
        in
            lib.mkIf zshUsed {
                enable = true;
            };
    };
}
