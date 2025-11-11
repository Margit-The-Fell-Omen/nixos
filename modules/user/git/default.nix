{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            git.enable = lib.mkEnableOption "git";
        };
    };

    config = lib.mkIf config.userSettings.git.enable {
        programs.git = {
            enable = true;
        };

        services.ssh-agent.enable = true;
    };
}
