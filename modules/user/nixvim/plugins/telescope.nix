{
    config,
    lib,
    pkgs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins = {
            telescope = {
                enable = true;
                settings.defaults = {
                    path_display = ["smart"];
                    vimgrep_arguments = [
                        "rg" # FIXME: detect if rg exists somehow?
                        "--color=never"
                        "--no-heading"
                        "--with-filename"
                        "--line-number"
                        "--column"
                        "--smart-case"
                        "--trim"
                    ];
                };
                extensions = {
                    fzf-native.enable = config.programs.fzf.enable;
                    zoxide.enable = config.programs.zoxide.enable; # NOTE: ?
                };
                keymaps = {
                    "<leader>ff" = {
                        action = "find_files";
                        options.desc = "[F]ind [f]iles";
                    };
                    "<leader>fs" = {
                        action = "live_grep";
                        options.desc = "[F]ind [s]trings";
                    };
                };
            };
        };
    };
}
