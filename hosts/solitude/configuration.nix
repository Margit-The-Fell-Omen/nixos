{...}: {
    config = {
        hostSettings = {
            kernel = {
                cachy = {
                    enable = true;
                    variant = "lto";
                    arch = "x86_64-v3";
                };

                tty0tty.enable = true;
            };

            users = [
                {
                    name = "deathlesz";
                    isAdmin = true;
                }
            ];

            security.sudo-rs.enable = true;

            hardware = {
                graphics = {
                    nvidia.enable = true;
                    amd.enable = true;
                };

                bluetooth.enable = true;

                laptop.enable = true;
            };

            audio.enable = true;

            sddm.enable = true;
            desktop.hyprland.enable = true;

            virtualization = {
                libvirt.enable = true;
                docker.enable = true;
            };

            mullvad.enable = true;

            gaming.enable = true;

            styling = {
                enable = true;

                theme = "gruvbox-medium";

                plymouth.enable = true;
                plymouth.theme = "arasaka";

                grub.theme = "cybergrub-2077";
            };
        };

        hardware.nvidia.prime = {
            nvidiaBusId = "PCI:1:0:0";
            amdgpuBusId = "PCI:6:0:0";
        };

        services = {
            # HACK: permanently symlink nVidia/AMD GPUs to specific paths so they can be used in `AQ_DRM_DEVICES`
            udev.extraRules = ''
                KERNEL=="card*", KERNELS=="0000:01:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/nvidia-dgpu"
                KERNEL=="card*", KERNELS=="0000:06:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/amd-igpu"
            '';

            supergfxd.enable = true;
            asusd = {
                enable = true;
                enableUserService = true;
            };
        };

        system.stateVersion = "25.05";
    };
}
