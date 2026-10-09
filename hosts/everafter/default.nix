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
        home-manager.users = lib.listToAttrs (map (user: {
            name = user.name;
            value = {
                _module.args.username = user.name;

                imports = [./home.nix ../../modules/user];
            };
        })
        config.hostSettings.users);

        system.stateVersion = "25.05";
    };
}
