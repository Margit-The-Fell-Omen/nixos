{
    osConfig,
    lib,
    ...
}: let
    hostFonts = osConfig.hostSettings.styling.fonts;
in {
    config = lib.mkIf osConfig.hostSettings.styling.enable {
        fonts.fontconfig = {
            enable = true;

            defaultFonts = {
                serif = [hostFonts.serif.name];
                sansSerif = [hostFonts.sansSerif.name];
                monospace = [hostFonts.monospace.name];
                emoji = [hostFonts.emoji.name];
            };
        };
    };
}
