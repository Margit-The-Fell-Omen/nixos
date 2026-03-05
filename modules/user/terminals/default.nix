{
    config,
    lib,
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

    imports = [
        ./kitty.nix
    ];

    config = {
        userSettings.terminals.kitty.enable = lib.mkIf (config.userSettings.terminals.defaultTerminal == "kitty") true;
    };
}
