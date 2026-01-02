{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: {
    # generally default values, can be changed by specific hosts
    config = {
        # needed to use all this
        nix = {
            settings = {
                experimental-features = ["nix-command" "flakes"];

                trusted-users = ["@wheel"];
                # try default cache server first
                # otherwise, try to pull from nix-community cachix server
                # otherwise, from garnix ci servers
                # last one is for cachyos kernels binary cache
                substituters = [
                    "https://cache.nixos.org"
                    "https://nix-community.cachix.org"
                    "https://cache.garnix.io"
                    "https://attic.xuyh0120.win/lantian"
                ];
                trusted-public-keys = [
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                ];
            };

            gc = lib.mkIf (! config.programs.nh.enable) {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 30d";
            };
        };

        nixpkgs = {
            config = {allowUnfree = true;};
            overlays = [inputs.nix-firefox-addons.overlays.default inputs.nix-cachyos-kernel.overlays.default];
        };

        environment.systemPackages = with pkgs; [
            git

            zip
            unzip
            rar
            gnutar
            p7zip

            curl
            wget

            ntfs3g
            xxd
        ];

        programs.nh = {
            enable = true;
            clean = {
                enable = true;
                dates = "monthly";
                extraArgs = "--keep 20 --keep-since 7d --optimise";
            };
            flake = "/home/deathlesz/dotfiles";
        };

        time.timeZone = "Europe/Minsk";
        services.chrony = {
            enable = true;
            servers = [
                "0.pool.ntp.org"
                "1.pool.ntp.org"
                "2.pool.ntp.org"
                "3.pool.ntp.org"
            ];
            serverOption = "iburst";
        };

        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings = {
            LC_ADDRESS = config.i18n.defaultLocale;
            LC_IDENTIFICATION = config.i18n.defaultLocale;
            LC_MEASUREMENT = config.i18n.defaultLocale;
            LC_MONETARY = config.i18n.defaultLocale;
            LC_NAME = config.i18n.defaultLocale;
            LC_NUMERIC = config.i18n.defaultLocale;
            LC_PAPER = config.i18n.defaultLocale;
            LC_TELEPHONE = config.i18n.defaultLocale;
            LC_TIME = config.i18n.defaultLocale;
        };

        # use zsh by default
        programs.zsh.enable = true;
        environment.shells = with pkgs; [zsh];
        users.defaultUserShell = pkgs.zsh;
        # completion for system packages (recommended according to home-manager docs)
        environment.pathsToLink = ["/share/zsh"];

        boot = {
            loader = {
                grub = {
                    enable = true;
                    efiSupport = true;
                    device = "nodev";
                    useOSProber = true;
                };

                efi = {
                    canTouchEfiVariables = true;
                    efiSysMountPoint = "/boot";
                };
            };

            # use systemd
            initrd.systemd.enable = true;
        };

        networking.networkmanager.enable = true;
        services.fstrim.enable = true;
    };
}
