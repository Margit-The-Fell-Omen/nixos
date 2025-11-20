{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            terminals.kitty.enable = lib.mkEnableOption "kitty";
        };
    };

    config = lib.mkIf config.userSettings.terminals.kitty.enable {
        programs.kitty = {
            enable = true;
            settings = {
                modify_font = "cell_width 90%";
                disable_ligatures = "cursor";
                # FIXME: maybe change depending on the colorscheme? looks kinda bad with (catppucchin/nord)?
                background_opacity = lib.mkForce "0.6"; # for some reason just `0.6` doesn't work
                enable_audio_bell = false;
                confirm_os_window_close = 0;
            };
        };
    };
}
