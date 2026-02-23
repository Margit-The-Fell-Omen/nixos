{
    config,
    lib,
    nixvimLib,
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

        ./plugins
    ];

    config = lib.mkIf config.userSettings.nixvim.enable {
        programs.nixvim = {
            enable = true;

            opts = import ./opts.nix;

            globals = {
                mapleader = " ";
                maplocalleader = " ";
            };
            keymaps = import ./keymaps.nix;

            autoGroups."highlight-yank".clear = true;
            autoCmd = [
                # for MASM
                {
                    event = ["FileType"];
                    pattern = ["masm" "asm"];
                    callback.__raw = ''
                        function()
                          vim.bo.tabstop = 8
                          vim.bo.shiftwidth = 8
                          vim.bo.expandtab = false
                          vim.bo.commentstring = "; %s"
                        end
                    '';
                }

                {
                    event = "TextYankPost";
                    desc = "highlight when yanking text";
                    group = "highlight-yank";
                    callback = nixvimLib.nixvim.mkRaw "function() vim.highlight.on_yank() end";
                }
            ];

            clipboard.providers.wl-copy.enable = true;

            performance = {
                byteCompileLua = {
                    enable = true;
                    luaLib = true;
                    nvimRuntime = true;
                    plugins = true;
                };
                combinePlugins = {
                    enable = true;
                    standalonePlugins = [
                        "oil.nvim"
                        "nvim-treesitter"
                    ];
                };
            };
        };

        # TODO: move to defaultEditor?
        home.sessionVariables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
        };
    };
}
