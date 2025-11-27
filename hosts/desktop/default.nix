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
        home-manager.users = lib.listToAttrs (map (username: {
            name = username;
            value = {imports = [./home-${username}.nix ../../modules/user];};
        })
        config.hostSettings.users);
    };
}
