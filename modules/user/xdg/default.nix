{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            xdg.enable = lib.mkEnableOption "XDG";
        };
    };

    config = lib.mkIf config.userSettings.xdg.enable {
        xdg.enable = true;
        xdg.userDirs = {
            enable = true;

            createDirectories = true;
            desktop = null;
            documents = null;
            download = "${config.home.homeDirectory}/downloads";
            music = "${config.home.homeDirectory}/media/music";
            pictures = "${config.home.homeDirectory}/media/pictures";
            publicShare = null;
            templates = null;
            videos = "${config.home.homeDirectory}/media/videos";
        };
        xdg.mimeApps.enable = true;
    };
}
