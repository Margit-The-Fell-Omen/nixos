{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.hostSettings.virtualization;
in {
    options = {
        hostSettings = {
            virtualization.enable = lib.mkEnableOption "virtualization";
        };
    };

    config = lib.mkIf cfg.enable {
        virtualisation.libvirtd = {
            enable = true;
            qemu = {
                package = pkgs.qemu_kvm; # disable unnecessary stuff for non-host emulation
                runAsRoot = true;
                swtpm.enable = true;
                vhostUserPackages = [pkgs.virtiofsd];
            };
        };

        programs.virt-manager.enable = true;
    };
}
