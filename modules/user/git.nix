{
    config,
    lib,
    ...
}: {
    options = {
        userSettings = {
            git.enable = lib.mkEnableOption "Git";
        };
    };

    config = lib.mkIf config.userSettings.git.enable {
        programs = {
            git.enable = true;
            lazygit = {
                enable = true;
                settings = {
                    git.overrideGpg = true;
                };
            };
        };
    };
}
