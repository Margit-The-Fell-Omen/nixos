{
    config,
    osConfig,
    lib,
    pkgs,
    ...
}: let
    colors = config.lib.stylix.colors;
    localState = "${config.home.homeDirectory}/.local/state/mpd";
in {
    config = lib.mkIf config.userSettings.misc.enable {
        programs = {
            cava = {
                enable = true;
                settings = lib.mkIf osConfig.hostSettings.pipewire.enable {
                    input.method = "pipewire";
                    input.source = "auto";
                    color = {
                        gradient = 1;
                        gradient_count = 8;
                        gradient_color_1 = "'#${colors.base08}'";
                        gradient_color_2 = "'#${colors.base09}'";
                        gradient_color_3 = "'#${colors.base0A}'";
                        gradient_color_4 = "'#${colors.base0B}'";
                        gradient_color_5 = "'#${colors.base0C}'";
                        gradient_color_6 = "'#${colors.base0D}'";
                        gradient_color_7 = "'#${colors.base0E}'";
                        gradient_color_8 = "'#${colors.base06}'";
                    };
                };
            };
            rmpc = {
                enable = true;
                config = builtins.replaceStrings ["@socket@"] ["${localState}/socket"] (builtins.readFile ./rmpc-config.ron);
            };
        };
        home.file.".config/rmpc/themes/mine.ron".text = builtins.replaceStrings
        [
            "@base08@"
            "@base09@"
            "@base0A@"
            "@base0B@"
            "@base0C@"
            "@base0D@"
            "@base0E@"
            "@base06@"
        ]
        [
            "${colors.base08}"
            "${colors.base09}"
            "${colors.base0A}"
            "${colors.base0B}"
            "${colors.base0C}"
            "${colors.base0D}"
            "${colors.base0E}"
            "${colors.base06}"
        ]
        (builtins.readFile ./rmpc-theme.ron);

        # HACK: can't create directories directly
        home.file.".config/mpd/playlists/.created".text = "";
        home.file.".local/state/mpd/.created".text = "";
        services.mpd = {
            enable = true;
            dbFile = "${config.home.homeDirectory}/.config/mpd/database";
            # the default
            # musicDirectory = config.xdg.userDirs.music;
            extraConfig = ''
                playlist_directory "${config.home.homeDirectory}/.config/mpd/playlists/"
                state_file "${localState}/state"

                audio_output {
                    type "pipewire"
                    name "PipeWire Sound Server"
                }

                audio_output {
                    type "fifo"
                    name "FIFO"
                    path "/tmp/mpd.fifo"
                    format "44100:16:2"
                }

                bind_to_address "${localState}/socket"

                auto_update "yes"
            '';
        };
        # is needed to use `playerctl` and for it to show on waybar
        # FIXME: waybar is lagging hard because of this (can't find something, idk)
        services.mpd-mpris.enable = false;

        home.sessionVariables = {
            MPD_HOST = "${localState}/socket";
        };
    };
}
