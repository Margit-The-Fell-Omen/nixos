{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: {
    config = {
        # Here go all per-user settings
        userSettings = {
            # Enable managing XDG stuff, you'll probably want this unless you're creating a server configuration
            xdg.enable = true;

            # Enable Hyprland
            hyprland.enable = true;

            # Enable NixVim
            nixvim.enable = true;

            # Use zsh by default
            shells.defaultShell = "zsh";

            # Enable zsh (technically not needed, as the declaration above will automatically set this to true)
            shells.zsh.enable = true;

            # Use Firefox by default
            browsers.defaultBrowser = "firefox";

            # Enable Firefox (also technically not needed)
            browsers.firefox.enable = true;

            # Use kitty by default
            terminals.defaultTerminal = "kitty";

            # Enable kitty (you see the pattern, hopefully)
            terminals.kitty.enable = true;

            # Enable various security-related features, like GPG, SSH
            security.enable = true;

            # Enable git (duh...)
            git.enable = true;

            # Styling stuff! (again?..)
            styling = {
                # Enable per-user styling with Stylix
                enable = true;

                # Theme to use (optional, is inherited from host-wide configuration)
                theme = "cyberpunk";

                # Set cursor theme (optional)
                cursor = {
                    name = "Quintom_Snow";
                    package = pkgs.quintom-cursor-theme;
                    size = 24;
                };

                # Set fonts (optional, is inherited from host-wide configuration)
                # font = {
                #     serif = {
                #         name = "Fira Sans";
                #         package = pkgs.fira-sans;
                #     };
                #     sansSerif = {
                #         name = "Fira Sans";
                #         package = pkgs.fira-sans;
                #     };
                #     monospace = {
                #         name = "JetBrainsMono Nerd Font";
                #         package = pkgs.nerd-fonts.jetbrains-mono;
                #     };
                #     emoji = {
                #         name = "Twitter Color Emoji";
                #         package = pkgs.twitter-color-emoji;
                #     };
                # };
            };

            # Miscellaneous programs and stuff (see declaration in `../../modules/user/misc/default.nix`)
            misc.enable = true;
        };

        # Set monitor configuration for Hyprland
        # You'll probably want this if you're using it
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
        # Example Git configuration
        # programs.git = {
        #    settings.user = {
        #        name = "Ushki";
        #         email = "wartim9494@gmail.com";
        #    };
        #
        #     signing = {
        #         key = "YOURSIGNINGKEYGOESHERE";
        #         signByDefault = true;
        #     };
        #  };

        # Example aliases
        # home.shellAliases = {
        #     ls = "eza --color=always";
        #     cat = "bat";
        #     ".." = "cd ..";
        # };

        # IMPORTANT: do not change
        home.stateVersion = "25.05";
    };
}
#

