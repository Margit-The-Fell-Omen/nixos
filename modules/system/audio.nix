{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings.audio.enable = lib.mkEnableOption "audio";
    };

    config = lib.mkIf config.hostSettings.audio.enable {
        security.rtkit.enable = true;
        services = {
            pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                jack.enable = true;

                wireplumber.enable = true;
            };

            playerctld.enable = true;
        };

        environment.systemPackages = with pkgs; [
            pavucontrol
        ];
    };
}
