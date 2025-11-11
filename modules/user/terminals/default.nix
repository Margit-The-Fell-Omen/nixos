{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            terminals.defaultTerminal = lib.mkOption {
                description = "Default terminal to use";
                type = lib.types.enum ["kitty"];
                default = "kitty";
            };
        };
    };

    config = {
        userSettings.terminals.kitty.enable = lib.mkIf (config.userSettings.terminals.defaultTerminal == "kitty") true;
    };
}
