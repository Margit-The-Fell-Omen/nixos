{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: let
    gpgKeyId = "F2C9CA3B08EFB236";

    toggleRefreshRate = pkgs.writeShellApplication {
        name = "toggle-refresh-rate";

        runtimeInputs = with pkgs; [
            libnotify
            jq
            bc
        ];

        text = builtins.readFile ./toggle-refresh-rate.sh;
    };
in {
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

            security.enable = true;
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

        programs.git = {
            settings.user = {
                name = "Deathlesz";
                email = "deathless.mcd@gmail.com";
            };

            signing = {
                key = gpgKeyId;
                signByDefault = true;
            };
        };

        # NOTE: comment if using dual monitors (or add nVidia GPU too?)
        home.sessionVariables = {
            AQ_DRM_DEVICES = "/dev/dri/amd-igpu";
        };

        wayland.windowManager.hyprland.settings = {
            monitor = [
                "eDP-1, 1920x1080@360.01, 0x0, 1"
                # "HDMI-A-1, 1920x1080@60.00, -1920x0, 1"
            ];

            bind = [
                ", XF86Launch4, exec, ${toggleRefreshRate}/bin/toggle-refresh-rate"
            ];
        };

        programs.mullvad-vpn = {
            enable = true;
            package = null;
            settings = {
                autoConnect = true;
                startMinimized = true;
            };
        };

        home.shellAliases = {
            ls = "eza --color=always";
            cat = "bat";
            ".." = "cd ..";
        };

        home.stateVersion = "25.05";
    };
}
