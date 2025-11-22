{
    config,
    lib,
    ...
}: {
    imports = [
        ./configuration.nix
        ./hardware-configuration.nix
    ];

    config = {
        home-manager.users = lib.listToAttrs (map (username: {
            name = username;
            value = {imports = [./home.nix ../../modules/user];};
        })
        config.hostSettings.users);

        system.stateVersion = "25.05";
    };
}
