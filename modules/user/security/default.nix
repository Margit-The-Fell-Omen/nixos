{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: {
    options = {
        userSettings = {
            security.enable = lib.mkEnableOption "secrets storage";
        };
    };

    config = lib.mkIf config.userSettings.security.enable {
        programs = {
            gpg = {
                enable = true;
            };
            ssh = {
                enable = true;
                enableDefaultConfig = false;
                matchBlocks."*".addKeysToAgent = "yes";
            };
        };

        services = {
            ssh-agent.enable = true;
            gpg-agent = {
                enable = true;
                enableSshSupport = false;
                pinentry = {
                    package = pkgs.pinentry-curses;
                    program = "pinentry-curses";
                };
            };
        };

        programs.zsh.initContent = lib.mkBefore ''
            export GPG_TTY=$(tty)
        '';
    };
}
