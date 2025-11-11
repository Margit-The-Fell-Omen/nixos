{...}: {
    imports = [
        ./hardware-configuration.nix
    ];

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/704c2560-6c3c-4246-bc7f-25e841e892c8";
        fsType = "btrfs";
        options = [
            "subvol=@"
            "compress=zstd"
            "noatime"
        ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/704c2560-6c3c-4246-bc7f-25e841e892c8";
        fsType = "btrfs";
        options = ["subvol=@home" "compress=zstd"];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/704c2560-6c3c-4246-bc7f-25e841e892c8";
        fsType = "btrfs";
        options = ["subvol=@nix" "compress=zstd"];
    };

    fileSystems."/var/log" = {
        device = "/dev/disk/by-uuid/704c2560-6c3c-4246-bc7f-25e841e892c8";
        fsType = "btrfs";
        options = ["subvol=@log" "compress=zstd"];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/7855-839E";
        fsType = "vfat";
    };
}
