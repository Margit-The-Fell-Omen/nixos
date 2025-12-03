{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.hostSettings.security;
in {
    options = {
        hostSettings = {
            security = {
                sudo-rs.enable = lib.mkEnableOption "sudo-rs as alternative to sudo";
            };
        };
    };

    config = {
        security.sudo-rs = lib.mkIf cfg.sudo-rs.enable {
            enable = true;
            execWheelOnly = true;
        };
    };
}
