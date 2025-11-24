{
    config,
    lib,
    ...
}: {
    config.programs.nixvim = lib.mkIf config.userSettings.nixvim.enable {
        plugins = {
            typst-preview = {
                enable = true;
                lazyLoad.settings.ft = "typst";
            };
        };
    };
}
