{
    config,
    osConfig,
    lib,
    libM,
    ...
}: {
    config = libM.requireHostSettings osConfig {
        require = ["hyprland" "graphics"];
        message = "Hyprland must also be enable on the system level";
    } (lib.mkIf config.userSettings.hyprland.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            package = null;
            portalPackage = null;
            settings = {
                "$terminal" = "${config.userSettings.terminals.defaultTerminal}";
                "$fileManager" = "${config.userSettings.terminals.defaultTerminal} --class yazi -- yazi";
                "$menu" = "rofi -show drun -theme ${config.home.homeDirectory}/.config/rofi/launcher.rasi";

                exec-once = [
                    "waybar"
                    "hyprctl setcursor ${config.userSettings.styling.cursor.name} ${builtins.toString config.userSettings.styling.cursor.size}"
                    "[workspace 1 silent] firefox"
                    "[workspace 2 silent] kitty"
                ];

                # debug = {
                #     disable_logs = false;
                # };

                general = {
                    gaps_in = 5;
                    gaps_out = 8;
                    border_size = 1;
                    resize_on_border = true;

                    allow_tearing = false;

                    layout = "dwindle";
                };

                decoration = {
                    rounding = 10;
                    rounding_power = 2;

                    active_opacity = 1.0;
                    inactive_opacity = 1.0;

                    dim_inactive = true;
                    dim_strength = 0.05;

                    shadow = {
                        enabled = true;
                        range = 4;
                        render_power = 3;
                    };

                    blur = {
                        enabled = true;
                        size = 6;
                        passes = 3;
                        new_optimizations = true;
                        ignore_opacity = true;

                        vibrancy = 0.1696;
                    };
                };

                animations = {
                    enabled = true;

                    bezier = [
                        "easeOutQuint,0.23,1,0.32,1"
                        "easeInOutCubic,0.65,0.05,0.36,1"
                        "linear,0,0,1,1"
                        "almostLinear,0.5,0.5,0.75,1.0"
                        "quick,0.15,0,0.1,1"
                    ];

                    animation = [
                        "global, 1, 10, default"
                        "border, 1, 5.39, easeOutQuint"
                        "windows, 1, 4.79, easeOutQuint"
                        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
                        "windowsOut, 1, 1.49, linear, popin 87%"
                        "fadeIn, 1, 1.73, almostLinear"
                        "fadeOut, 1, 1.46, almostLinear"
                        "fade, 1, 3.03, quick"
                        "layers, 1, 3.81, easeOutQuint"
                        "layersIn, 1, 4, easeOutQuint, fade"
                        "layersOut, 1, 1.5, linear, fade"
                        "fadeLayersIn, 1, 1.79, almostLinear"
                        "fadeLayersOut, 1, 1.39, almostLinear"
                        "workspaces, 1, 1.94, almostLinear, fade"
                        "workspacesIn, 1, 1.21, almostLinear, fade"
                        "workspacesOut, 1, 1.94, almostLinear, fade"
                    ];
                };

                dwindle = {
                    pseudotile = true;
                    preserve_split = true;
                };

                master = {
                    new_status = "master";
                };

                misc = {
                    force_default_wallpaper = 0;
                    disable_hyprland_logo = true;
                    disable_splash_rendering = true;

                    mouse_move_enables_dpms = true;
                    key_press_enables_dpms = true;

                    enable_swallow = true;
                    swallow_regex = "^(${config.userSettings.terminals.defaultTerminal})$";
                };

                cursor = lib.mkIf osConfig.hostSettings.graphics.nvidia.enable {
                    no_hardware_cursors = 1;
                };

                input = {
                    kb_layout = "us, ru";
                    kb_variant = "";
                    kb_model = "";
                    kb_options = "grp:caps_toggle";
                    kb_rules = "";

                    follow_mouse = 1;
                    sensitivity = -0.1;

                    touchpad = {
                        natural_scroll = true;
                    };
                };

                windowrulev2 = [
                    # ignore maximize requests from apps
                    "suppressevent maximize, class:.*"

                    # xix some dragging issues with XWayland
                    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

                    # make satty look better
                    "float,class:^com.gabm.satty$"
                    "dimaround,class:^com.gabm.satty$"
                    "minsize 700 500,class:^com.gabm.satty$"

                    # rmpc & cava
                    "float,class:^rmpc$"
                    "size 60% 50%,class:^rmpc$"

                    "float,class:^cava$"
                    "size 30% 20%,class:^cava$"

                    "float,class:^yazi$"
                    "size 80% 80%,class:^yazi$"
                ];

                "$mainMod" = "SUPER";

                bind = [
                    "$mainMod, Q, exec, $terminal"
                    "$mainMod, C, killactive,"
                    "$mainMod, M, exit,"
                    "$mainMod, E, exec, $fileManager"
                    "$mainMod, F, togglefloating,"
                    "$mainMod, R, exec, $menu"

                    # switch workspaces with mainMod + [0-9]
                    "$mainMod, 1, workspace, 1"
                    "$mainMod, 2, workspace, 2"
                    "$mainMod, 3, workspace, 3"
                    "$mainMod, 4, workspace, 4"
                    "$mainMod, 5, workspace, 5"
                    "$mainMod, 6, workspace, 6"
                    "$mainMod, 7, workspace, 7"
                    "$mainMod, 8, workspace, 8"
                    "$mainMod, 9, workspace, 9"
                    "$mainMod, 0, workspace, 10"

                    # move active window to a workspace with mainMod + SHIFT + [0-9]
                    "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
                    "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
                    "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
                    "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
                    "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
                    "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
                    "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
                    "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
                    "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
                    "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

                    # special workspace (scratchpad)
                    "$mainMod, S, togglespecialworkspace, magic"
                    "$mainMod SHIFT, S, movetoworkspace, special:magic"

                    # scroll through existing workspaces with mainMod + scroll
                    "$mainMod, mouse_down, workspace, e+1"
                    "$mainMod, mouse_up, workspace, e-1"

                    # custom

                    # open clipboard history
                    # "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

                    # move windows with J, K (left, right) and Shift+J, K (down, up)
                    "$mainMod, J, movewindow, l"
                    "$mainMod, K, movewindow, r"
                    "$mainMod SHIFT, J, movewindow, d"
                    "$mainMod SHIFT, K, movewindow, u"

                    # switch between 60 Hz and 360 Hz
                    # ",XF86Launch4, exec, hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1"
                    # "SHIFT,XF86Launch4, exec, hyprctl keyword monitor eDP-1,1920x1080@360,0x0,1"

                    # wallpapers
                    # ", XF86Launch1, exec, ~/.config/hypr/random_wallpapers.sh"
                    # "SHIFT, XF86Launch1, exec, ~/.config/hypr/animated_wallpapers.sh"

                    # power menu
                    "$mainMod, KP_ENTER, exec, ~/.config/rofi/powermenu.sh"

                    # blue light filter
                    "$mainMod, KP_ADD, exec, hyprsunset --temperature 4500"
                    "$mainMod SHIFT, KP_ADD, exec, killall hyprsunset"

                    # screenshot
                    # just select
                    ", PRINT, exec, grimblast -n -f copy area"
                    "$mainMod, PRINT, exec, grimblast -n -f save area ~/\${date '+%Y-%m-%d_%H:%M:%S'}.png"

                    # do stuff
                    "SHIFT, PRINT, exec, GRIMBLAST_EDITOR=\"satty --actions-on-enter save-to-clipboard,exit --filename \" grimblast -f edit area"

                    # full screen
                    "ALT, PRINT, exec, grimblast -n -f copy screen"
                    "$mainMod + ALT, PRINT, exec, grimblast -n -f save screen ~/\$(date '+%Y-%m-%d_%H:%M:%S').png"

                    # bluetooth
                    # "$mainMod, B, exec, ~/.config/hypr/rofi-bluetooth.sh"

                    # lock
                    "$mainMod, L, exec, hyprlock"

                    # music
                    "$mainMod, N, exec, $terminal --class rmpc -- rmpc"
                    "$mainMod SHIFT, N, exec, $terminal --class cava -- cava"
                ];

                bindm = [
                    # move/resize windows with mainMod + LMB/RMB and dragging
                    "$mainMod, mouse:272, movewindow"
                    "$mainMod, mouse:273, resizewindow"
                ];

                bindel = [
                    # laptop multimedia keys for volume and LCD brightness
                    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
                    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
                    ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
                    ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
                ];

                bindl = [
                    ", XF86AudioNext, exec, playerctl next"
                    ", XF86AudioPause, exec, playerctl play-pause"
                    ", XF86AudioPlay, exec, playerctl play-pause"
                    ", XF86AudioPrev, exec, playerctl previous"
                ];

                layerrule = [
                    "blur, rofi"
                ];
            };

            xwayland.enable = true;
        };
    });
}
