{...}: {
    imports = [
        ./hardware-configuration.nix
    ];

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/e997b557-aaae-4ae9-ba54-3fc734712faa";
        fsType = "btrfs";
        options = ["subvol=@" "compress=zstd" "noatime"];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/e997b557-aaae-4ae9-ba54-3fc734712faa";
        fsType = "btrfs";
        options = ["subvol=@home" "compress=zstd"];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/e997b557-aaae-4ae9-ba54-3fc734712faa";
        fsType = "btrfs";
        options = ["subvol=@nix" "compress=zstd"];
    };

    fileSystems."/var/log" = {
        device = "/dev/disk/by-uuid/e997b557-aaae-4ae9-ba54-3fc734712faa";
        fsType = "btrfs";
        options = ["subvol=@log" "compress=zstd"];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/8FAF-3D35";
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
    };

    # mount windows partitions and allow all users access
    fileSystems."/mnt/c" = {
        device = "/dev/disk/by-uuid/6648A7C748A79479";
        fsType = "ntfs";
        options = ["umask=000" "windows_names"];
    };

    fileSystems."/mnt/d" = {
        device = "/dev/disk/by-uuid/847C21A67C219448";
        fsType = "ntfs";
        options = ["umask=000" "windows_names"];
    };
}
