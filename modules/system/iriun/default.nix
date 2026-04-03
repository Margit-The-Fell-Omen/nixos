{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        hostSettings = {
            iriun.enable = lib.mkEnableOption "Iriun Webcam";
        };
    };

    config = lib.mkIf config.hostSettings.iriun.enable {
        services = {
            usbmuxd.enable = true;
            avahi = {
                # required for Wi-Fi discovery
                enable = true;
                nssmdns4 = true;
                openFirewall = true;
            };
        };

        boot = {
            extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
            kernelModules = ["v4l2loopback"];
            extraModprobeConfig = ''options v4l2loopback exclusive_caps=1 devices=1 card_label="Iriun Webcam,Iriun Webcam #2,Iriun Webcam #3,Iriun Webcam #4'';
        };

        environment.systemPackages = [(pkgs.callPackage ./iriun.nix {}) pkgs.android-tools];
    };
}
