{...}: {
    imports = [
        ./configuration.nix

        ./audio.nix
        ./gaming.nix
        ./mullvad.nix
        ./users.nix
        ./virtualization.nix

        ./desktop
        ./hardware
        ./iriun
        ./kernel
        ./sddm
        ./security
        ./styling
    ];
}
