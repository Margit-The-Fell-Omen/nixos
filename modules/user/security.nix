{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            security.enable = lib.mkEnableOption "security features";
        };
    };

    config = lib.mkIf config.userSettings.security.enable {
        programs = {
            gpg.enable = true;
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
                    package = pkgs.pinentry-qt;
                    program = "pinentry-qt";
                };
            };
        };

        programs.zsh.initContent = lib.mkBefore ''
            export GPG_TTY=$(tty)
        '';
    };
}
