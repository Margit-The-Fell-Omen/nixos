{
    config,
    lib,
    ...
}: {
    options = {
        hostSettings = {
            docker.enable = lib.mkEnableOption "docker";
        };
    };

    config = lib.mkIf config.hostSettings.docker.enable {
        virtualisation.docker = {
            enable = true;
        };
    };
}
