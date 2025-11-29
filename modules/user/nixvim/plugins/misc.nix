{
    config,
    lib,
    nixvimLib,
    pkgs,
    inputs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins = {
            lz-n.enable = true;
            dressing = {
                enable = true;
                lazyLoad.settings.event = "DeferredUIEnter";
            };
            bufferline = {
                enable = true;
                settings = {
                    options = {
                        mode = "tabs";
                        # separator_style = "slant";
                    };
                };
            };
            web-devicons.enable = true;
            oil.enable = true;
            tmux-navigator = {
                enable = true;
            };
            sleuth.enable = true;
            nvim-autopairs = {
                enable = true;
                lazyLoad.settings.event = "InsertEnter";
            };
            nvim-surround = {
                enable = true;
                lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
            };

            # comments
            comment = {
                enable = true;
                lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
            };
            todo-comments = {
                enable = true;
                lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
            };

            indent-blankline = {
                enable = true;
                lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
            };
            lualine.enable = true;
        };

        extraPlugins = with pkgs; [vimPlugins.substitute-nvim];
        extraConfigLua = ''
            require("lz.n").load({
                "substitute",
                event = {"BufReadPre", "BufNewFile"},
                after = function()
                    require("substitute").setup()
                end
            });
        '';

        keymaps = [
            {
                mode = "n";
                key = "s";
                action = nixvimLib.nixvim.mkRaw "require(\"substitute\").operator";
                options.desc = "[S]ubstitute with motion";
            }
            {
                mode = "n";
                key = "ss";
                action = nixvimLib.nixvim.mkRaw "require(\"substitute\").line";
                options.desc = "[S]ubstitute line";
            }
            {
                mode = "n";
                key = "S";
                action = nixvimLib.nixvim.mkRaw "require(\"substitute\").eol";
                options.desc = "[S]ubstitute to EOL";
            }
            {
                mode = "x";
                key = "s";
                action = nixvimLib.nixvim.mkRaw "require(\"substitute\").visual";
                options.desc = "[S]ubstitute in visual mode";
            }
            {
                mode = "n";
                key = "<C-o>";
                action = "<CMD>Oil<CR>";
                options.desc = "Open [O]il";
            }
        ];
    };
}
