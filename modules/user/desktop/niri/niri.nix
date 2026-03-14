{
    config,
    lib,
    osConfig,
    inputs,
    ...
}: {
    imports = [
        inputs.niri.homeModules.niri
    ];

    config = lib.mkIf osConfig.hostSettings.desktop.niri.enable {
        programs.niri.enable = true;
    };
}
