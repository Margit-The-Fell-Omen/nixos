{
    config,
    lib,
    pkgs,
    ...
}: {
    config = {
        # Here you set all the (host/system)-wide settings
        hostSettings = {
            # Enable CachyOS LTO kernel
            cachy.enable = true;
            # Enable microarchitecture optimizations
            # cachy.arch = "GENERIC_V3";

            # Users to create on the machine (you will need to create `home-{username}.nix` files for each such user)
            users = ["username"];

            # Users to grant admin (i.e. `sudo`) privileges
            adminUsers = ["username"];

            # Enable security-related stuff, like changing sudo to sudo-rs
            security.enable = true;

            # Enable graphics support
            graphics.enable = true;

            # Enable nVidia GPU support
            graphics.nvidia.enable = true;

            # Enable AMD GPU support
            graphics.amd.enable = true;

            # Configure various laptop-related features, like nVidia Prime
            # If you enable this and you have a dual GPU setup with nVidia
            # You must set `hardware.nvidia.prime.{nvidiaBusId,amdgpuBusId,intelBusId}` to appropriate values
            laptop.enable = true;

            # Enable Bluetooth support
            bluetooth.enable = true;

            # Enable audio through Pipewire
            pipewire.enable = true;

            # Enable host-wide Hyprland settings (is required to enable on per-user basis)
            hyprland.enable = true;

            # Enable SDDM
            sddm.enable = true;

            # Enable Docker
            docker.enable = true;

            # Styling-related features
            styling = {
                # Enable styling through Stylix
                enable = true;

                # Host-wide theme to use, see `../../modules/themes/`
                theme = "everforest-medium";

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

                # Theme for splash screen, see `../../modules/system/styling/plymouth/themes/`
                # By default, shows NixOS logo
                # plymouth.theme = "ecorp-glitch";

                # GRUB theme to use, see `../../modules/system/styling/grub/themes/`
                grub.theme = "cybergrub-2077";
            };
        };

        # IMPORTANT: set to the value in `/etc/nixos/configuration.nix` and NEVER change it again
        # for explanation, see the comments in the aforementioned file
        system.stateVersion = "25.05";
    };
}
