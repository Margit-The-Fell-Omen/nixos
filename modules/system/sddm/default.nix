{
    config,
    lib,
    pkgs,
    ...
}: let
    colors = config.lib.stylix.colors;
    theme = pkgs.sddm-astronaut.override {
        themeConfig = {
            # FIXME: unfortunately, background will only be based on the one
            # in the theme, because backgrounds are per-user and this is not :(
            Background = config.stylix.image;

            # FullBlur = "true";
            # BlurMax = "64";
            # Blur = "2.0";
            FormPosition = "right";
            # HideVirtualKeyboard = "true";

            HeaderTextColor = "#${colors.base05}";
            DateTextColor = "#${colors.base05}";
            TimeTextColor = "#${colors.base05}";

            FormBackgroundColor = "#${colors.base00}";
            BackgroundColor = "#${colors.base00}";
            DimBackgroundColor = "#${colors.base00}";

            LoginFieldBackgroundColor = "#${colors.base01}";
            PasswordFieldBackgroundColor = "#${colors.base01}";

            LoginFieldTextColor = "#${colors.base05}";
            PasswordFieldTextColor = "#${colors.base05}";
            UserIconColor = "#${colors.base05}";
            PasswordIconColor = "#${colors.base05}";

            PlaceholderTextColor = "#${colors.base03}";
            WarningColor = "#${colors.base08}";

            LoginButtonTextColor = "#${colors.base07}";
            LoginButtonBackgroundColor = "#${colors.base0D}";
            SystemButtonsIconsColor = "#${colors.base05}";
            SessionButtonTextColor = "#${colors.base05}";
            VirtualKeyboardButtonTextColor = "#${colors.base05}";

            DropdownTextColor = "#${colors.base07}";
            DropdownSelectedBackgroundColor = "#${colors.base02}";
            DropdownBackgroundColor = "#${colors.base05}";

            HighlightTextColor = "#${colors.base03}";
            HighlightBackgroundColor = "#${colors.base0B}";
            HighlightBorderColor = "transparent";

            HoverUserIconColor = "#${colors.base0A}";
            HoverPasswordIconColor = "#${colors.base0A}";
            HoverSystemButtonsIconsColor = "#${colors.base0A}";
            HoverSessionButtonTextColor = "#${colors.base0A}";
            HoverVirtualKeyboardButtonTextColor = "#${colors.base0A}";
        };
    };
in {
    options = {
        hostSettings = {
            sddm.enable = lib.mkEnableOption "SDDM";
        };
    };

    config = lib.mkIf config.hostSettings.sddm.enable {
        services.displayManager.sddm = {
            enable = true;
            wayland.enable = true;
            autoNumlock = true;
            theme = "${theme}/share/sddm/themes/sddm-astronaut-theme";
            # NOTE: needed anyway even though theme is referenced above
            extraPackages = [
                theme
            ];
        };
    };
}
