{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.hostSettings.kernel;

    kernel =
        "linuxPackages-cachyos-latest"
        + (
            if cfg.cachy.variant == "lto"
            then "-lto"
            else ""
        )
        + (
            if cfg.cachy.arch != null
            then "-" + cfg.cachy.arch
            else ""
        );
in {
    options = {
        hostSettings = {
            kernel = {
                cachy = {
                    enable = lib.mkEnableOption "CachyOS kernel";
                    variant = lib.mkOption {
                        type = lib.types.enum ["lto" "gcc"];
                        description = "Which CachyOS kernel package to use";
                        default = "lto";
                    };
                    arch = lib.mkOption {
                        type = lib.types.nullOr (lib.types.enum ["x86_64-v2" "x86_64-v3" "x86_64-v4" "zen4"]);
                        description = "Enable microarchitecture optimizations";
                        default = null;
                    };
                };

                tty0tty.enable = lib.mkEnableOption "tty0tty";
            };
        };
    };

    config = lib.mkMerge [
        (lib.mkIf cfg.cachy.enable {
            boot.kernelPackages = pkgs.cachyosKernels."${kernel}";
            hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;

            services.scx = {
                enable = true;
                scheduler = "scx_lavd"; # NOTE: i think it's the best one? maybe try bpfland as well?
            };
        })

        (lib.mkIf cfg.tty0tty.enable {
            boot = {
                extraModulePackages = [(config.boot.kernelPackages.callPackage ./tty0tty.nix {})];
                kernelModules = ["tty0tty"];
            };

            services.udev.extraRules = ''
                KERNEL=="tnt[0-9]*", MODE="0666"
            '';
        })
    ];
}
