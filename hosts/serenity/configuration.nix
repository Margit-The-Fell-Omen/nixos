{pkgs, ...}: {
    config = {
        hostSettings = {
            cachy = {
                enable = true;
                variant = "lto";
                arch = "x86_64-v3";
            };

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

            mullvad.enable = true;

            gaming.enable = true;

            styling = {
                enable = true;

                theme = "rose-pine-moon";

                plymouth.enable = true;
                plymouth.theme = "arasaka";

                grub.theme = "cybergrub-2077";
            };
        };

        system.stateVersion = "25.05";
    };
}
