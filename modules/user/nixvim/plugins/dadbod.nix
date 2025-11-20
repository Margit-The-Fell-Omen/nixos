{
    config,
    lib,
    pkgs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins = {
            vim-dadbod.enable = true;
            vim-dadbod-completion.enable = true;
            vim-dadbod-ui.enable = true;
        };

        globals.db_ui_use_nerd_fonts = 1;
    };
}
