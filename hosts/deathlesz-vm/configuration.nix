{
    config,
    lib,
    pkgs,
    ...
}: {
    config = {
        hostSettings = {
            users = ["deathlesz"];
            adminUsers = ["deathlesz"];

            graphics.enable = true;
            graphics.virtio.enable = true;
            # bluetooth.enable = true;

            pipewire.enable = true;
            hyprland.enable = true;
            sddm.enable = true;

            styling = {
                enable = true;

                theme = "everforest-medium";

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
