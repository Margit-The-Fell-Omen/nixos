{
    config,
    lib,
    pkgs,
    ...
}: {
    config = {
        # Here you set all the (host/system)-wide settings
        environment.systemPackages = [
            pkgs.cmake
            pkgs.libgcc
            pkgs.llvmPackages_20.systemLibcxxClang
            pkgs.qtcreator
            pkgs.steam
            pkgs.libreoffice
            pkgs.jetbrains.idea

            pkgs.dosbox-staging
            pkgs.picocom
            pkgs.socat
            pkgs.jq
            pkgs.unrar
            pkgs.postgresql_16
        ];

        virtualisation.docker.enable = true;
        # Change to docker for docker
        users.users.ushki.extraGroups = ["dialout"];

        # 1. Allow unfree packages (Steam is proprietary)
        nixpkgs.config.allowUnfree = true;

        # 2. Enable Steam
        programs.steam = {
            enable = true;
            # Open ports in the firewall for Steam Remote Play (optional)
            remotePlay.openFirewall = true;
            # Open ports for Source Dedicated Server (optional)
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

            postgresql = {
                enable = true;
                port = 5432;
                databases = ["mydb" "testdb"];
                users = [
                    {
                        name = "myuser";
                        password = "mypassword";
                        databases = ["mydb"];
                    }
                    {
                        name = "testuser";
                        password = "testpass";
                        databases = ["testdb"];
                    }
                ];
            };

            # Users to create on the machine (you will need to create `home-{username}.nix` files for each such user)
            users = ["ushki"];

            # Users to grant admin (i.e. `sudo`) privileges
            adminUsers = ["ushki"];

            mullvad.enable = true;
            security.sudo-rs.enable = true;

            # Enable graphics support
            graphics.enable = true;

            # Enable nVidia GPU support
            graphics.nvidia.enable = true;

            # Enable AMD GPU support
            graphics.amd.enable = false;

            # Configure various laptop-related features, like nVidia Prime
            # If you enable this and you have a dual GPU setup with nVidia
            # You must set `hardware.nvidia.prime.{nvidiaBusId,amdgpuBusId,intelBusId}` to appropriate values
            laptop.enable = false;

            # Enable Bluetooth support
            bluetooth.enable = true;

            # Enable audio through pipewirte
            pipewire.enable = true;

            # Enable host-wide Hyprland settings (is required to enable on per-user basis)
            hyprland.enable = true;

            # Enable SDDM
            sddm.enable = true;

            # Styling-related features
            styling = {
                # Enable styling through Stylix
                enable = true;

                # Host-wide theme to use, see `../../modules/themes/`
                theme = "signalis";

                # Host-wide font configuration
                fonts = {
                    serif = {
                        name = "Fira Sans";
                        package = pkgs.fira-sans;
                    };
                    # sansSerif = ... # same options
                    # monospace = ... # same options
                    # emoji = ... # same options
                };

                # Enable splash screen on load instead of raw TTY
                plymouth.enable = true;
                plymouth.theme = "arasaka";

                # GRUB theme to use, see `../../modules/system/styling/grub/themes/`
                grub.theme = "cybergrub-2077";
            };
        };

        # IMPORTANT: set to the value in `/etc/nixos/configuration.nix` and NEVER change it again
        # for explanation, see the comments in the aforementioned file
        system.stateVersion = "25.05";
    };
}
