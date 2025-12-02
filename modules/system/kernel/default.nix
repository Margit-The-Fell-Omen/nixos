{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.hostSettings.cachy;
in {
    options = {
        hostSettings = {
            cachy.enable = lib.mkEnableOption "CachyOS kernel";
            cachy.variant = lib.mkOption {
                type = lib.types.enum ["lto" "gcc"];
                description = "Which CachyOS kernel package to use";
                default = "lto";
            };
            cachy.arch = lib.mkOption {
                type = lib.types.nullOr (lib.types.enum ["GENERIC_V2" "GENERIC_V3" "GENERIC_V4" "ZEN4"]);
                description = "Enable microarchitecture optimizations";
                default = null;
            };
        };
    };

    config = lib.mkIf cfg.enable {
        boot.kernelPackages =
            if cfg.arch != null
            then (pkgs."linuxPackages_cachyos-${cfg.variant}".cachyOverride {mArch = cfg.arch;})
            else (pkgs."linuxPackages_cachyos-${cfg.variant}");

        services.scx = {
            enable = true;
            scheduler = "scx_lavd"; # NOTE: i think it's the best one? maybe try bpfland as well?
        };
    };
}
