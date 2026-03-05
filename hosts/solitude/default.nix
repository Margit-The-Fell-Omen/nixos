{
    config,
    lib,
    ...
}: {
    imports = [
        ./configuration.nix
        ./hardware-configuration-additional.nix
    ];

    config = {
        home-manager.users = lib.listToAttrs (map (user: {
            name = user.name;
            value = {imports = [./home-${user.name}.nix ../../modules/user];};
        })
        config.hostSettings.users);

        system.stateVersion = "25.05";
    };
}
