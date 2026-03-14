{...}: {
    config = {
        hostSettings = {
            kernel.cachy = {
                enable = true;
                variant = "lto";
                arch = "x86_64-v3";
            };

            users = [
                {
                    name = "deathlesz";
                    isAdmin = true;
                }
            ];

            security.sudo-rs.enable = true;

            hardware = {
                graphics.nvidia.enable = true;
                bluetooth.enable = true;
            };

            audio.enable = true;

            sddm.enable = true;
            desktop = {
                hyprland.enable = true;
                niri.enable = true;
            };

            virtualization.docker.enable = true;

            mullvad.enable = true;

            gaming.enable = true;

            styling = {
                enable = true;

                theme = "everforest-medium";

                plymouth.enable = true;
                plymouth.theme = "arasaka";

                grub.theme = "cybergrub-2077";
            };
        };

        system.stateVersion = "25.05";
    };
}
