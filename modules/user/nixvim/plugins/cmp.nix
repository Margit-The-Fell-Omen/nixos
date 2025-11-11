{
    config,
    lib,
    pkgs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins.blink-cmp = {
            enable = true;
            settings = {
                keymap = {
                    preset = "default";
                    "<C-k>" = ["select_prev" "fallback"];
                    "<C-j>" = ["select_next" "fallback"];
                    "<C-b>" = ["scroll_documentation_up" "fallback"];
                    "<C-f>" = ["scroll_documentation_down" "fallback"];
                    "<C-space>" = ["show" "fallback"];
                    "<C-e>" = ["hide" "fallback"];
                    "<CR>" = ["accept" "fallback"];
                    "<C-l>" = ["snippet_forward" "fallback"];
                    "<C-h>" = ["snippet_backward" "fallback"];
                };

                sources = {
                    default = ["lsp" "path" "snippets" "buffer"];
                    # default = [ "lazydev" "lsp" "path" "snippets" "buffer" "crates" ];
                    # per_filetype = {
                    #     sql = [ "snippets" "dadbod" "buffer" ];
                    # };
                    providers = {
                        # lazydev = {
                        #     name = "LazyDev";
                        #     module = "lazydev.integration.blink";
                        #     score_offset = 100;
                        # };
                        # dadbod = {
                        #     name = "Dadbod";
                        #     module = "vim_dadbod_completion.blink";
                        # };
                        # crates = {
                        #     name = "crates";
                        #     module = "blink.compat.source";
                        #     score_offset = 100;
                        # };
                    };
                };

                signature.enabled = true;
                completion = {
                    ghost_text.enabled = true;
                    menu.direction_priority = {
                        __raw = ''
                            function()
                                local ctx = require("blink.cmp").get_context()
                                local item = require("blink.cmp").get_selected_item()
                                if ctx == nil or item == nil then
                                    return { "s", "n" };
                                end

                                local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
                                local is_multi_line = item_text:find("\n") ~= nil

                                if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                                    vim.g.blink_cmp_upwards_ctx_id = ctx.id
                                    return { "n", "s" }
                                end

                                return { "s", "n" }
                            end
                        '';
                    };
                    documentation = {
                        auto_show = true;
                        auto_show_delay_ms = 200;
                    };
                };

                fuzzy.implementation = "prefer_rust_with_warning";
            };
        };
    };
}
