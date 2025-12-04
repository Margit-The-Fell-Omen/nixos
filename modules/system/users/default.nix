{
    config,
    lib,
    ...
}: {
    options = {
        hostSettings = {
            users = lib.mkOption {
                description = "List of users to create on the host";
                type = lib.types.listOf lib.types.str;
            };
            adminUsers = lib.mkOption {
                description = "List of users to grant admin privileges on the host";
                type = lib.types.listOf lib.types.str;
            };
        };
    };

    config = {
        users.users = lib.listToAttrs (map (username: {
            name = username;
            value = {
                isNormalUser = true;
                extraGroups =
                    ["networkmanager"]
                    ++ (lib.optionals (lib.any (x: x == username) config.hostSettings.adminUsers) ["wheel"])
                    ++ (lib.optional config.hostSettings.docker.enable "docker")
                    ++ (lib.optional config.hostSettings.virtualization.enable "libvirtd");
                createHome = true;
            };
        })
        config.hostSettings.users);

        home-manager.users = lib.listToAttrs (map (username: {
            name = username;
            value = {
                home = {
                    inherit username;
                    homeDirectory = "/home/${username}";
                };
            };
        })
        config.hostSettings.users);
    };
}
