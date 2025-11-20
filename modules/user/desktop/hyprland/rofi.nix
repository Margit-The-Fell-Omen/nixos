{
    config,
    lib,
    libM,
    pkgs,
    osConfig,
    ...
}: let
    mkLiteral = config.lib.formats.rasi.mkLiteral;
    mkRgb = color: let
        c = config.lib.stylix.colors;
        r = c."${color}-rgb-r";
        g = c."${color}-rgb-g";
        b = c."${color}-rgb-b";
    in
        mkLiteral "rgba(${r}, ${g}, ${b}, 100%)";

    toList = x:
        if builtins.isList x
        then x
        else [x];
    font = {
        name = builtins.head (toList config.userSettings.styling.fonts.monospace.name);
        size = builtins.head (toList config.userSettings.styling.fonts.monospace.size);
    };
in {
    config = libM.requireHostSettings osConfig {
        require = ["hyprland" "graphics"];
        message = "Hyprland must also be enable on the system level";
    } (lib.mkIf config.userSettings.hyprland.enable {
        programs.rofi = {
            enable = true;
            font = "${font.name} 12";
            theme = {
                "*" = {
                    background = mkRgb "base00";
                    lightbg = mkRgb "base01";
                    red = mkRgb "base08";
                    blue = mkRgb "base0D";
                    lightfg = mkRgb "base06";
                    foreground = mkRgb "base05";

                    background-color = mkRgb "base00";
                    separatorcolor = mkLiteral "@foreground";
                    border-color = mkLiteral "@foreground";
                    selected-normal-foreground = mkLiteral "@lightbg";
                    selected-normal-background = mkLiteral "@lightfg";
                    selected-active-foreground = mkLiteral "@background";
                    selected-active-background = mkLiteral "@blue";
                    selected-urgent-foreground = mkLiteral "@background";
                    selected-urgent-background = mkLiteral "@red";
                    normal-foreground = mkLiteral "@foreground";
                    normal-background = mkLiteral "@background";
                    active-foreground = mkLiteral "@blue";
                    active-background = mkLiteral "@background";
                    urgent-foreground = mkLiteral "@red";
                    urgent-background = mkLiteral "@background";
                    alternate-normal-foreground = mkLiteral "@foreground";
                    alternate-normal-background = mkLiteral "@lightbg";
                    alternate-active-foreground = mkLiteral "@blue";
                    alternate-active-background = mkLiteral "@lightbg";
                    alternate-urgent-foreground = mkLiteral "@red";
                    alternate-urgent-background = mkLiteral "@lightbg";

                    base-text = mkRgb "base05";
                    selected-normal-text = mkRgb "base01";
                    selected-active-text = mkRgb "base00";
                    selected-urgent-text = mkRgb "base00";
                    normal-text = mkRgb "base05";
                    active-text = mkRgb "base0D";
                    urgent-text = mkRgb "base08";
                    alternate-normal-text = mkRgb "base05";
                    alternate-active-text = mkRgb "base0D";
                    alternate-urgent-text = mkRgb "base08";
                };
            };
        };
        home.file."${config.home.homeDirectory}/.config/rofi/launcher.rasi".source = ./launcher.rasi;
        home.file."${config.home.homeDirectory}/.config/rofi/powermenu.rasi".source = ./powermenu.rasi;
        home.file."${config.home.homeDirectory}/.config/rofi/powermenu.sh" = {
            source = ./powermenu.sh;
            executable = true;
        };

        # NOTE: custom implementation is needed due to stylix putting config for elements
        # and some opacity stuff which breaks everything
        stylix.targets.rofi.enable = false;
    });
}
