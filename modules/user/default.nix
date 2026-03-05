{...}: {
    imports = [
        ./home.nix
        ./git.nix
        ./mullvad.nix
        ./security.nix
        ./xdg.nix

        ./browsers
        ./desktop
        ./editors
        ./misc
        ./shells
        ./styling
        ./terminals
    ];
}
