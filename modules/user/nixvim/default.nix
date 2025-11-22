{
    config,
    lib,
    nixvimLib,
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
                    callback = nixvimLib.nixvim.mkRaw "function() vim.highlight.on_yank() end";
                }
            ];

            clipboard.providers.wl-copy.enable = true;

            # PERF: is this good?
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

        home.sessionVariables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
        };
    };
}
