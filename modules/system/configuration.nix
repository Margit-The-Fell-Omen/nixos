{
    config,
    lib,
    pkgs,
    inputs,
    system,
    ...
}: {
    # generally default values, can be changed by specific hosts
    config = {
        # needed to use all this
        nix.settings.experimental-features = ["nix-command" "flakes"];

        nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
        };

        # TODO: add alejandra
        environment.systemPackages = with pkgs; [
            git

            zip
            unzip
            rar
            gnutar
            p7zip

            curl
            wget

            inputs.alejandra.defaultPackage.${system}
        ];

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
            initrd = {
                systemd.enable = true;
                # quiet boot
                verbose = false;
            };

            # quiet boot
            kernelParams = [
                "quiet"
                "splash"
                "loglevel=3"
                "systemd.show_status=false"
                "udev.log_level=3"
                "udev.log_priority=3"
            ];

            # renders splash and picks up screen resolution ASAP
            plymouth.enable = true;
        };

        networking.networkmanager.enable = true;
        # FIXME: move somewhere
        services.openssh.enable = true;

        # i don't use nano, so i don't need it
        programs.nano.enable = lib.mkForce false;
    };
}
