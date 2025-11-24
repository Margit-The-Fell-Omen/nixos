{
    config,
    lib,
    pkgs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins.conform-nvim = {
            enable = true;
            lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
            settings = {
                notify_on_error = false;
                formatters_by_ft = {
                    lua = ["stylua"];
                    rust = ["rustfmt"];
                    typst = ["typstyle"];
                    nix = ["alejandra"];
                };
                format_after_save = {
                    lsp_fallback = true;
                    async = true;
                    timeout_ms = 500;
                };
                formatters.rustfmt = {
                    command = "rustfmt +nightly fmt";
                    prepend_args = ["--unstable-features"];
                };
            };
        };
    };
}
