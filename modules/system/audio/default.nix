{
    config,
    lib,
    pkgs,
    ...
}: {
    config = lib.mkIf config.hostSettings.pipewire.enable {
        services.playerctld = {
            enable = true;
        };

        environment.systemPackages = with pkgs; [
            pavucontrol
        ];
    };
}
