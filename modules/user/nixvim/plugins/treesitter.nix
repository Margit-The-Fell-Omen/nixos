{
    config,
    lib,
    pkgs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins.treesitter = {
            enable = true;
            nixvimInjections = true;
            settings = {
                hightlight.enable = true;
                indent.enable = true;
                autotag.enable = true;
                ensure_installed = [
                    "json"
                    "markdown"
                    "markdown_inline"
                    "bash"
                    "lua"
                    "vim"
                    "vimdoc"

                    "c"
                    "cpp"
                    "rust"
                    "nix"
                ];
            };
        };
    };
}
