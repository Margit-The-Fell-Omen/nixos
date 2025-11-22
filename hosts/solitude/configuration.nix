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
            graphics.nvidia.enable = true;
            graphics.amd.enable = true;
            laptop.enable = true;
            bluetooth.enable = true;

            pipewire.enable = true;
            hyprland.enable = true;
            sddm.enable = true;

            styling = {
                enable = true;

                theme = "nord";

                plymouth.enable = true;
                plymouth.theme = "ecorp-glitch";

                grub.theme = "cybergrub-2077";
            };
        };

        graphics.nvidia.prime = {
            nvidiaBusId = "PCI:1@0:0.0";
            amdgpuBusId = "PCI:6@0:0.0";
        };

        system.stateVersion = "25.05";
    };
}
