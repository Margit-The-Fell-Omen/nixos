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

            hyprland.enable = true;
            nixvim.enable = true;

            shells.defaultShell = "zsh";
            shells.zsh.enable = true;

            browsers.defaultBrowser = "firefox";
            browsers.firefox.enable = true;

            terminals.defaultTerminal = "kitty";
            terminals.kitty.enable = true;

            git.enable = true;

            styling = {
                enable = true;
                # cursor = {
                #   name = "Quintom_Snow";
                #   package = pkgs.quintom-cursor-theme;
                #   size = 24;
                # };
                # font = {
                #   defaultSerif = {
                #     name = "Fira Sans";
                #     package = pkgs.fira-sans;
                #   };
                #   defaultSansSerif = {
                #     name = "Fira Sans";
                #     package = pkgs.fira-sans;
                #   };
                #   defaultMonospace = {
                #     name = "JetBrainsMono Nerd Font";
                #     package = pkgs.nerd-fonts.jetbrains-mono;
                #   };
                #   defaultEmoji = {
                #     name = "Twitter Color Emoji";
                #     package = pkgs.twitter-color-emoji;
                #   };
                # };
                #
                # stylix.theme = "nord";
            };

            misc.enable = true;
        };

        programs = {
            git.settings.user = {
                name = "deathlesz";
                email = "deathless.mcd@gmail.com";
            };
        };

        wayland.windowManager.hyprland.settings = {
            monitor = [
                "Virtual-1, 1920x1080@60, 0x0, 1"
            ];
        };

        home.shellAliases = {
            ls = "eza --color=always";
            cat = "bat";
            ".." = "cd ..";
        };

        home.stateVersion = "25.05";
    };
}
