{
    config,
    lib,
    pkgs,
    inputs,
    ...
}: let
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

            nixvim.enable = true;

            browsers.defaultBrowser = "firefox";
            browsers.firefox.enable = true;

            terminals.defaultTerminal = "kitty";
            terminals.kitty.enable = true;

            security.enable = true;
            git.enable = true;

            misc.enable = true;
        };

        wayland.windowManager.hyprland.settings = {
            monitor = [
                "DP-1, 2560x1440@165, 0x0, 1"
                "HDMI-A-1, 1920x1080@75, -1920x0, 1"
            ];
        };

        programs.obsidian.enable = true;

        programs.git = {
            enable = true;
            userName = "Ushki";
            userEmail = "wartim9494@gmail.com";
        };

        programs = {
            zsh.initContent = lib.mkAfter ''
                ${quote}/bin/quote
            '';
        };

        home.stateVersion = "25.05";
    };
}
#

