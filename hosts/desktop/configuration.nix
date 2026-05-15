{
    config,
    lib,
    pkgs,
    ...
}: {
    config = {
        environment.systemPackages = [
            pkgs.cmake
            pkgs.libgcc
            pkgs.llvmPackages_20.systemLibcxxClang
            pkgs.steam
            pkgs.libreoffice
            pkgs.jetbrains.idea

            # АПК
            pkgs.dosbox-staging

            # Java
            pkgs.jq
            pkgs.unrar
            pkgs.postgresql_16
            pkgs.postman
            pkgs.jmeter
            pkgs.redis
            pkgs.google-cloud-sdk

            pkgs.discord

            # ОСиСП
            pkgs.gcc
            pkgs.gnumake
            pkgs.valgrind
            pkgs.mc
            pkgs.tree
            pkgs.unixtools.netstat
        ];

        virtualisation.docker.enable = true;
        users.users.ushki.extraGroups = ["docker"];

        nixpkgs.config.allowUnfree = true;

        programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
        };

        hardware.nvidia-container-toolkit.enable = lib.mkForce false;

        hostSettings = {
            kernel = {
                cachy = {
                    enable = true;
                    variant = "lto";
                    arch = "x86_64-v3";
                };

                tty0tty.enable = true;
            };

            users = [
                {
                    name = "ushki";
                    isAdmin = true;
                }
            ];

            mullvad.enable = true;
            security.sudo-rs.enable = true;

            hardware = {
                graphics = {
                    nvidia.enable = true;
                    amd.enable = false;
                };

                bluetooth.enable = true;

                laptop.enable = false;
            };

            audio.enable = true;

            desktop.hyprland.enable = true;

            sddm.enable = true;

            styling = {
                enable = true;

                theme = "cyberpunk";

                fonts = {
                    serif = {
                        name = "Fira Sans";
                        package = pkgs.fira-sans;
                    };
                };

                plymouth.enable = true;
                plymouth.theme = "arasaka";

                grub.theme = "cybergrub-2077";
            };
        };

        system.stateVersion = "25.05";
    };
}
