{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        userSettings = {
            shells.zsh.enable = lib.mkEnableOption "zsh";
        };
    };

    config = lib.mkIf config.userSettings.shells.zsh.enable {
        home.packages = lib.optionals config.programs.fzf.enable (with pkgs; [
            zsh-fzf-tab
        ]);

        programs.zsh = {
            enable = true;
            dotDir = "${config.xdg.configHome}/zsh";
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            history = {
                size = 5000;
                save = 5000;
                append = true;
                share = true;
                ignoreSpace = true;
                ignoreDups = true;
                ignoreAllDups = true;
                saveNoDups = true;
                findNoDups = true;
            };
            localVariables.HISTDUP = "erase";

            defaultKeymap = "emacs";

            initContent = let
                # HACK: a workaround to load `fzf-tab` before `zsh-autosuggestions` and `zsh-syntax-highlighting`
                # but after `compinit` (order 570)
                beforeAutosuggestions =
                    if config.programs.fzf.enable
                    then
                        (lib.mkOrder 580 ''
                            source "${pkgs.zsh-fzf-tab.outPath}/share/fzf-tab/fzf-tab.plugin.zsh"
                        '')
                    else '''';
                normal = lib.concatStringsSep "\n" [
                    "zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'"
                    "zstyle ':completion:*' list-colors \"\${(s.:.)LS_COLORS}\""
                    "zstyle ':completion:*' menu no"
                    # use `eza` if it's available
                    (
                        if config.programs.eza.enable
                        then ''
                            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
                            zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
                        ''
                        else ''
                            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
                            zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color=always $realpath'
                        ''
                    )
                    "bindkey '^p' history-search-backward"
                    "bindkey '^n' history-search-forward"
                ];
                after = lib.mkAfter ''
                    fastfetch
                '';
            in
                lib.mkMerge [beforeAutosuggestions normal after];
        };

        # enable zsh integrations for all available applications
        home.shell.enableZshIntegration = true;
    };
}
