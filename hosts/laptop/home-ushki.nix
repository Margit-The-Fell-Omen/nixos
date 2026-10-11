{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: {
    config = {
        userSettings = {
            xdg.enable = true;

            nixvim.enable = true;

            browsers.defaultBrowser = "firefox";
            browsers.firefox.enable = true;

            terminals.defaultTerminal = "kitty";
            terminals.kitty.enable = true;

            security.enable = true;
            git.enable = true;

            misc.enable = true;
        };

        wayland.windowManager.hyprland.settings = {
            monitor = [
                "eDP-1, 1920x1080@60, 0x0, 1"
            ];
        };

        programs.git = {
            enable = true;
            userName = "Ushki";
            userEmail = "wartim9494@gmail.com";
        };

        home.stateVersion = "25.05";
    };
}
#

