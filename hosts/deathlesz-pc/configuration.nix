{
    config,
    lib,
    pkgs,
    ...
}: {
    config = {
        hostSettings = {
            users = ["deathlesz"];
            adminUsers = ["deathlesz"];

            graphics.enable = true;
            graphics.nvidia.enable = true;
            bluetooth.enable = true;

            pipewire.enable = true;
            hyprland.enable = true;

            stylix.enable = true;
            stylix.theme = "everforest-medium";
        };

        system.stateVersion = "25.05";
    };
}
