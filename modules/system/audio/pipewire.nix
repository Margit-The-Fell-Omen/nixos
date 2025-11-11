{
    config,
    lib,
    ...
}: {
    options = {
        hostSettings.pipewire.enable = lib.mkEnableOption "pipewire";
    };

    config = lib.mkIf config.hostSettings.pipewire.enable {
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;

            wireplumber.enable = true;
        };
    };
}
