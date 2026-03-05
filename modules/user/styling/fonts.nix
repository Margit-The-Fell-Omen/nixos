{
    osConfig,
    lib,
    ...
}: let
    toList = x:
        if builtins.isList x
        then x
        else [x];

    hostFonts = osConfig.hostSettings.styling.fonts;
in {
    config = lib.mkIf osConfig.hostSettings.styling.enable {
        fonts.fontconfig = {
            enable = true;

            defaultFonts = {
                serif = toList hostFonts.serif.name;
                sansSerif = toList hostFonts.sansSerif.name;
                monospace = toList hostFonts.monospace.name;
                emoji = toList hostFonts.emoji.name;
            };
        };
    };
}
