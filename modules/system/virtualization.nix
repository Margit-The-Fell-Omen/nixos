{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings = {
            virtualization = {
                libvirt.enable = lib.mkEnableOption "libvirt support";
                docker.enable = lib.mkEnableOption "Docker support";
            };
        };
    };

    config = lib.mkMerge [
        (lib.mkIf
        config.hostSettings.virtualization.libvirt.enable
        {
            virtualisation.libvirtd = {
                enable = true;

                qemu = {
                    package = pkgs.qemu_kvm;
                    vhostUserPackages = [pkgs.virtiofsd];
                };
            };

            programs.virt-manager.enable = true;
        })
        (lib.mkIf
        config.hostSettings.virtualization.docker.enable
        {
            virtualisation.docker.enable = true;
        })
    ];
}
