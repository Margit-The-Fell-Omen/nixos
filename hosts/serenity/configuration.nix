{pkgs, ...}: {
    config = {
        hostSettings = {
            kernel = {
                cachy = {
                    enable = true;
                    variant = "lto";
                    arch = "x86_64-v3";
                };
            };

            users = ["deathlesz"];
            adminUsers = ["deathlesz"];

            security.sudo-rs.enable = true;

            graphics.enable = true;
            graphics.nvidia.enable = true;

            pipewire.enable = true;
            bluetooth.enable = true;
            mullvad.enable = true;

            sddm.enable = true;
            hyprland.enable = true;

            gaming.enable = true;

            docker.enable = true;

            styling = {
                enable = true;

                theme = "tokyo-night";

                plymouth.enable = true;
                plymouth.theme = "arasaka";

                grub.theme = "cybergrub-2077";
            };
        };

        system.stateVersion = "25.05";
    };
}
