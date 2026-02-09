{
    config,
    pkgs,
    lib,
    ...
}: {
    options = {
        userSettings = {
            idea.enable = lib.mkEnableOption "IDEA";
        };
    };

    config = let
        idea = pkgs.jetbrains.idea;

        idea-version = builtins.splitVersion idea.version;
        idea-version-major-minor = builtins.concatStringsSep "." [(builtins.elemAt idea-version 0) (builtins.elemAt idea-version 1)];

        javaagent = pkgs.fetchzip {
            url = "https://3.jetbra.in/files/jetbra-5a50fc03d68a014f893b7fc3aa465380d59f9095.zip";
            hash = "sha256-iCtLAmJ1uBU2VtU/EbgASI5Ws9pUJUpWxOB6xsZjgVs=";
        };
    in
        lib.mkIf config.userSettings.idea.enable {
            home.packages = with pkgs; [
                jetbrains.idea
            ];

            home.file.".ideavimrc".source = ./.ideavimrc;
            xdg.configFile."JetBrains/IntelliJIdea${idea-version-major-minor}/idea64.vmoptions".text = "-javaagent:${javaagent}/ja-netfilter.jar=jetbrains";
        };
}
