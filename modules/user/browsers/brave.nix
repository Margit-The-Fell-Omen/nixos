{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            browsers.brave.enable = lib.mkEnableOption "Brave";
        };
    };

    config = lib.mkIf config.userSettings.browsers.brave.enable {
        home.packages = with pkgs; [
            brave
        ];
    };
}
