{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins.trouble = {
            enable = true;
            lazyLoad.settings = {
                cmd = "Trouble";
                keys = [
                    {
                        __unkeyed-1 = "<leader>xw";
                        __unkeyed-2 = "<CMD>Trouble diagnostics toggle<CR>";
                        desc = "Open trouble workspace diagnostics";
                    }
                    {
                        __unkeyed-1 = "<leader>xd";
                        __unkeyed-2 = "<CMD>Trouble diagnostics toggle filter.buf=0<CR>";
                        desc = "Open trouble document diagnostics";
                    }
                    {
                        __unkeyed-1 = "<leader>xq";
                        __unkeyed-2 = "<CMD>Trouble quickfix toggle<CR>";
                        desc = "Open trouble quickfix list";
                    }
                    {
                        __unkeyed-1 = "<leader>xl";
                        __unkeyed-2 = "<CMD>Trouble loclist toggle<CR>";
                        desc = "Open trouble location list";
                    }
                    {
                        __unkeyed-1 = "<leader>xt";
                        __unkeyed-2 = "<CMD>Trouble todo toggle<CR>";
                        desc = "Open todos in trouble";
                    }
                ];
            };
            settings.focus = true;
        };
    };
}
