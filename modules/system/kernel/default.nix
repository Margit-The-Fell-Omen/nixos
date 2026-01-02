{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.hostSettings.cachy;

    kernel =
        "linuxPackages-cachyos-latest"
        + (
            if cfg.variant == "lto"
            then "-lto"
            else ""
        )
        + (
            if cfg.arch != null
            then "-" + cfg.arch
            else ""
        );
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
                type = lib.types.nullOr (lib.types.enum ["x86_64-v2" "x86_64-v3" "x86_64-v4" "zen4"]);
                description = "Enable microarchitecture optimizations";
                default = null;
            };
        };
    };

    config = lib.mkIf cfg.enable {
        boot.kernelPackages = pkgs.cachyosKernels."${kernel}";

        services.scx = {
            enable = true;
            scheduler = "scx_lavd"; # NOTE: i think it's the best one? maybe try bpfland as well?
        };
    };
}
