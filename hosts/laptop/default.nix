{
    config,
    lib,
    ...
}: {
    # add additional imports here if needed
    imports = [
        ./configuration.nix
        ./hardware-configuration-additional.nix
    ];

    config = {
        # do not change; automatically imports everything needed
        home-manager.users = lib.listToAttrs (map (user: {
            name = user.name;
            value = {
                _module.args.username = user.name;

                imports = [./home-${user.name}.nix ../../modules/user];
            };
        })
        config.hostSettings.users);

        system.stateVersion = "25.05";
    };
}
