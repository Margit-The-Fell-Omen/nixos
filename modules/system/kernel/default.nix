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
            then (pkgs.linuxPackages_cachyos-lto.cachyOverride {mArch = cfg.arch;})
            else (pkgs.linuxPackages_cachyos-lto);

        services.scx = {
            enable = true;
            scheduler = "scx_lavd"; # NOTE: i think it's the best one? maybe try bpfland as well?
        };
    };
}
