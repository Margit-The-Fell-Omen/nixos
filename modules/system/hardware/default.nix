{...}: {
    imports = [
        ./graphics

        ./bluetooth.nix
        ./laptop.nix
    ];

    config = {
        hardware.enableAllFirmware = true;
    };
}
