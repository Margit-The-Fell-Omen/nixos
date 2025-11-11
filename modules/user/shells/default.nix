{
    config,
    osConfig,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            shells.defaultShell = lib.mkOption {
                description = "Default shell to use";
                type = lib.types.enum ["zsh"];
                default = "zsh";
            };
        };
    };

    config = {
        userSettings.shells.zsh.enable = lib.mkIf (config.userSettings.shells.defaultShell == "zsh") true;

        programs.fzf = {
            enable = true;
            tmux.enableShellIntegration = true;
        };
        programs.zoxide = {
            enable = true;
            options = ["--cmd cd"];
        };
        programs.tmux = {
            enable = true;
            sensibleOnTop = true;
            terminal = "\${TERM}";

            escapeTime = 0;
            mouse = true;

            keyMode = "vi";
            shortcut = "Space";

            plugins = [
                {
                    plugin = pkgs.tmuxPlugins.yank;
                }
                {
                    plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
                }
            ];

            extraConfig = ''
                set -g base-index 1
                set -g pane-base-index 1
                set-window-option -g pane-base-index 1
                set-option -g renumber-windows on

                bind-key -r -T prefix C-Up resize-pane -U
                bind-key -r -T prefix C-Down resize-pane -D
                bind-key -r -T prefix C-Left resize-pane -L
                bind-key -r -T prefix C-Right resize-pane -R

                bind-key -T copy-move-vi v send-keys -X begin-selection
                bind-key -T copy-move-vi C-v send-keys -X rectangle toggle
                bind-key -T copy-move-vi y send-key -X copy-selection-and-cancel

                bind \\ split-window -h -c "''${pane_current_path}"
                bind - split-window -v -c "''${pane_current_path}"
                unbind '"'
                unbind %
            '';
        };
    };
}
