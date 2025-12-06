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
        home-manager.users = lib.listToAttrs (map (username: {
            name = username;
            value = {imports = [./home-${username}.nix ../../modules/user];};
        })
        config.hostSettings.users);

        system.stateVersion = "25.05";
    };
}
