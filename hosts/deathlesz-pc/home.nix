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

            stylix.enable = true;
            stylix.theme = "everforest-medium";
        };

        home.packages = with pkgs; [
            # utils
            ripgrep

            # fastfetch, lol
            fastfetch

            jetbrains-mono
            nerd-fonts.jetbrains-mono
        ];

        programs = {
            btop = {
                enable = true;
                # needed for btop to show nVidia & AMD GPUs
                package = pkgs.btop.override {
                    cudaSupport = true;
                    rocmSupport = true;
                };
                settings = {
                    # color_theme = "everforest-dark-medium";
                    # NOTE: ?
                    theme_background = true;
                    truecolor = true;
                    vim_keys = true;
                    update_ms = 100;
                };
            };
            bat.enable = true;
            eza.enable = true;
            git.settings.user = {
                name = "deathlesz";
                email = "deathless.mcd@gmail.com";
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
