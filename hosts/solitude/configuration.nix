{config, ...}: {
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

            users = ["deathlesz"];
            adminUsers = ["deathlesz"];

            security.sudo-rs.enable = true;

            graphics.enable = true;
            graphics.nvidia.enable = true;
            graphics.amd.enable = true;
            laptop.enable = true;

            pipewire.enable = true;
            bluetooth.enable = true;

            sddm.enable = true;
            hyprland.enable = true;

            docker.enable = true;
            virtualization.enable = true;

            mullvad.enable = true;

            gaming.enable = true;

            styling = {
                enable = true;

                theme = "tokyo-night";

                plymouth.enable = true;
                plymouth.theme = "arasaka";

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
            blocky = {
                enable = false;
                settings = {
                    upstreams.groups.default = [
                        "https://1.1.1.1/dns-query#cloudflare-dns.com"
                        "https://mozilla.cloudflare-dns.com/dns-query"
                        "https://dns.google/dns-query"
                        "https://unfiltered.adguard-dns.com/dns-query"
                        "https://wikimedia-dns.org/dns-query"
                        "https://freedns.controld.com/p0"
                    ];

                    blocking = {
                        denylists.ai = [
                            ./blocklist.txt
                        ];
                        clientGroupsBlock.default = ["ai"];
                    };
                };
            };
            supergfxd.enable = true;
            asusd = {
                enable = true;
                enableUserService = true;
            };
        };

        # networking.nameservers = [
        #     "127.0.0.1"
        # ];

        system.stateVersion = "25.05";
    };
}
