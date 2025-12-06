{pkgs, ...}: {
    config = {
        hostSettings = {
            cachy.enable = true;
            cachy.variant = "gcc";
            # cachy.arch = "GENERIC_V3";

            users = ["deathlesz"];
            adminUsers = ["deathlesz"];

            security.sudo-rs.enable = true;

            graphics.enable = true;
            graphics.nvidia.enable = true;

            pipewire.enable = true;
            bluetooth.enable = true;

            sddm.enable = true;
            hyprland.enable = true;

            docker.enable = true;

            gaming.enable = true;

            styling = {
                enable = true;

                theme = "everforest-medium";

                plymouth.enable = true;
                plymouth.theme = "arasaka";

                grub.theme = "cybergrub-2077";
            };
        };

        services = {
            mullvad-vpn = {
                enable = true;
                package = pkgs.mullvad-vpn;
            };
        };

        system.stateVersion = "25.05";
    };
}
