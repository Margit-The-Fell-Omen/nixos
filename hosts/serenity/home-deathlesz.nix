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
        };

        programs = {
            mullvad-vpn = {
                enable = true;
                package = null;
                settings = {
                    autoConnect = true;
                    startMinimized = true;
                };
            };
            zsh.initContent = lib.mkAfter ''
                ${quote}/bin/quote
            '';
        };

        home.packages = with pkgs; [
            telegram-desktop
        ];

        home.shellAliases = {
            ls = "eza --color=always";
            cat = "bat";
            ".." = "cd ..";
        };

        home.stateVersion = "25.05";
    };
}
