{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: {
    options = {
        userSettings = {
            nixvim.enable = lib.mkEnableOption "NixVim";
        };
    };

    imports = [
        inputs.nixvim.homeModules.nixvim
    ];

    config = lib.mkIf config.userSettings.nixvim.enable {
        home.packages = with pkgs; [
            nixd
        ];

        programs.nixvim = {
            enable = true;

            # needed to build treesitter parsers
            extraPackages = with pkgs; [clang];

            opts = import ./opts-config.nix;

            globals = {
                mapleader = " ";
                maplocalleader = " ";
            };
            keymaps = import ./keymaps-config.nix;
            autoGroups."highlight-yank".clear = true;
            autoCmd = [
                {
                    event = "TextYankPost";
                    desc = "highlight when yanking text";
                    group = "highlight-yank";
                    callback = {__raw = "function() vim.highlight.on_yank() end";};
                }
            ];

            clipboard.providers.wl-copy.enable = true;

            performance.byteCompileLua.plugins = true; # NOTE: is this good?
            plugins = {
                lz-n.enable = true;
                # trouble = {
                # 	enable = true;
                # 	settings.focus = true;
                #
                # };
                oil.enable = true;
                tmux-navigator = {
                    enable = true;
                };
                dressing = {
                    enable = true;
                    lazyLoad.settings.event = "DeferredUIEnter";
                };
                sleuth.enable = true;
                nvim-autopairs = {
                    enable = true;
                    lazyLoad.settings.event = "InsertEnter";
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
                comment = {
                    enable = true;
                    lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
                };
                nvim-surround = {
                    enable = true;
                    lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
                };
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
                        fzf-native.enable = true;
                        zoxide.enable = true; # NOTE: ?
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
                todo-comments = {
                    enable = true;
                    lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
                };
                web-devicons.enable = true;
                vim-dadbod.enable = true;
                vim-dadbod-completion.enable = true;
                vim-dadbod-ui.enable = true;
            };

            globals.db_ui_use_nerd_fonts = 1;
        };

        home.sessionVariables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
        };
    };
}
