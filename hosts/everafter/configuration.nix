{...}: {
    config = {
        hostSettings = {
            # Users to create on the machine
            #
            # `isAdmin = true` grants the user `sudo` privileges (i.e. adds them to the `wheel` group)
            users = [
                {
                    name = "deathlesz";
                    isAdmin = true;
                }
            ];

            hardware = {
                graphics.virtio.enable = true;

                # bluetooth.enable = true;
            };

            # Enable audio through Pipewire
            audio.enable = true;

            desktop.hyprland.enable = true;

            sddm.enable = true;

            styling = {
                enable = true;

                theme = "nord";

                plymouth.enable = true;
                # FIXME: maybe it doesn't work on VM?
                #
                plymouth.theme = "ecorp-glitch";

                grub.theme = "cybergrub-2077";
            };
        };

        system.stateVersion = "25.05";
    };
}
