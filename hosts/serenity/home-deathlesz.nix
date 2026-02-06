{
    lib,
    pkgs,
    ...
}: let
    gpgKeyId = "F2C9CA3B08EFB236";

    quote = pkgs.stdenv.mkDerivation rec {
        pname = "quote";
        version = "296c0de08f9a35da05ffecb8decc5f602b54dd72";

        src = pkgs.fetchFromGitHub {
            owner = "deathlesz";
            repo = "quote";
            rev = version;
            hash = "sha256-+rErlBeYMR12YJRUo3mmHuEhWpPUUVKbzf0/t5b/Cio=";
        };

        nativeBuildInputs = with pkgs; [
            nasm
        ];

        buildPhase = ''
            nasm -felf64 quote.a -o quote.o
            ld quote.o -o quote
        '';

        installPhase = ''
            runHook preInstall

            mkdir -p $out/bin/
            cp quote $out/bin/

            runHook postInstall
        '';
    };

    nnedi3-nns128-win8x4 = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/bjin/mpv-prescalers/refs/heads/master/compute/nnedi3-nns128-win8x4.hook";
        hash = "sha256-9DvgfvQlDx7iRpUBMM0BUrndbiTlAH47cOE2cpDIl7A=";
    };

    artcnn-c4f32 = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Artoriuz/ArtCNN/refs/heads/main/GLSL/ArtCNN_C4F32.glsl";
        hash = "sha256-93O85s9f5+Xl1Zmmle3UDfXNeiDD0IxNFk0HWR1b6tM=";
    };
in {
    config = {
        userSettings = {
            xdg.enable = true;

            hyprland.enable = true;
            nixvim.enable = true;

            shells.defaultShell = "zsh";
            shells.zsh.enable = true;

            browsers.defaultBrowser = "firefox";
            browsers.firefox.enable = true;

            terminals.defaultTerminal = "kitty";
            terminals.kitty.enable = true;

            security.enable = true;
            git.enable = true;

            styling.enable = true;

            misc.enable = true;
        };

        programs.git = {
            settings.user = {
                name = "Deathlesz";
                email = "deathless.mcd@gmail.com";
            };

            signing = {
                key = gpgKeyId;
                signByDefault = true;
            };
        };

        wayland.windowManager.hyprland.settings = {
            monitor = [
                "HDMI-A-1, 1920x1080@74.97, 0x0, 1"
            ];

            exec-once = [
                "[workspace 3 silent] obsidian"
            ];
        };

        programs = {
            obsidian.enable = true;
            zsh.initContent = lib.mkAfter ''
                ${quote}/bin/quote
            '';

            mpv = {
                bindings = {
                    g = "cycle-values glsl-shaders \"${nnedi3-nns128-win8x4}\" \"${artcnn-c4f32}\" \"\"";
                };
                defaultProfiles = ["high-quality"];
                config = {
                    vo = "gpu-next";

                    slang = "enm,eng,en";
                    alang = "jpn,ja";
                };
            };
        };

        home.packages = with pkgs; [
            jetbrains.idea

            prismlauncher
            telegram-desktop

            qbittorrent
        ];

        home.file.".ideavimrc".source = ./.ideavimrc;

        home.shellAliases = {
            ls = "eza --color=always";
            cat = "bat";
            ".." = "cd ..";
        };

        home.stateVersion = "25.05";
    };
}
