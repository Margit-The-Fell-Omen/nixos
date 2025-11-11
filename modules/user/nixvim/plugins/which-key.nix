{
    config,
    lib,
    pkgs,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins.which-key = {
            enable = true;
            lazyLoad.settings = {
                event = "DeferredUIEnter";
            };
            settings = {
                spec = [
                    {
                        __unkeyed = "<leader>t";
                        desc = "[T]ab";
                    }
                    {
                        __unkeyed = "<leader>s";
                        desc = "[S]plit";
                    }
                    {
                        __unkeyed = "<leader>f";
                        desc = "[F]ind";
                    }
                    {
                        __unkeyed = "<leader>x";
                        desc = "Trouble";
                    }
                ];
            };
        };
    };
}
