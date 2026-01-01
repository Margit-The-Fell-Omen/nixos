{
    lib,
    pkgs,
    ...
}: let
    gpgKeyId = "F2C9CA3B08EFB236";

    toggleRefreshRate = pkgs.writeShellApplication {
        name = "toggle-refresh-rate";

        runtimeInputs = with pkgs; [
            libnotify
            jq
            bc
        ];

        text = builtins.readFile ./toggle-refresh-rate.sh;
    };

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

        # NOTE: comment if using dual monitors (or add nVidia GPU too?)
        home.sessionVariables = {
            AQ_DRM_DEVICES = "/dev/dri/amd-igpu";
        };

        wayland.windowManager.hyprland.settings = {
            monitor = [
                "eDP-1, 1920x1080@360.01, 0x0, 1"
                # "HDMI-A-1, 1920x1080@60.00, -1920x0, 1"
            ];

            bind = [
                ", XF86Launch4, exec, ${toggleRefreshRate}/bin/toggle-refresh-rate"
            ];

            exec-once = [
                "[workspace 3 silent] obsidian"
            ];
        };

        programs = {
            obsidian = {
                enable = true;
            };
            mullvad-vpn = {
                enable = true;
                package = null;
                settings = {
                    autoConnect = true;
                    startMinimized = true;
                };
            };
            vesktop = {
                enable = true;
            };
            zsh.initContent = lib.mkAfter ''
                ${quote}/bin/quote
            '';
        };

        home.packages = with pkgs; [
            telegram-desktop

            libreoffice-qt-fresh
            hunspell
            hunspellDicts.ru_RU
            hunspellDicts.en_US-large

            hyphenDicts.ru_RU
            hyphenDicts.en_US
        ];

        home.shellAliases = {
            ls = "eza --color=always";
            cat = "bat";
            ".." = "cd ..";
        };

        home.stateVersion = "25.05";
    };
}
