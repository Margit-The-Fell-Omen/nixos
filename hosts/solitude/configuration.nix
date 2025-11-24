{pkgs, ...}: {
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

                theme = "everforest-medium";

                plymouth.enable = true;
                # plymouth.theme = "ecorp-glitch";

                grub.theme = "cybergrub-2077";
            };
        };

        hardware.nvidia.prime = {
            nvidiaBusId = "PCI:1:0:0";
            amdgpuBusId = "PCI:6:0:0";
        };

        # HACK: permanently symlink nVidia/AMD GPUs to specific paths so they can be used in `AQ_DRM_DEVICES`
        #
        services.udev.extraRules = ''
            KERNEL=="card*", KERNELS=="0000:01:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidia-dgpu"
            KERNEL=="card*", KERNELS=="0000:06:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/amd-igpu"
        '';

        services = {
            supergfxd.enable = true;
            asusd = {
                enable = true;
                enableUserService = true;
            };
            mullvad-vpn = {
                enable = true;
                package = pkgs.mullvad-vpn;
            };
        };

        system.stateVersion = "25.05";
    };
}
