{ config, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/dotfiles";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

    # .config/<directory>
    configs = {
        alacritty = "alacritty";
        hypr = "hypr";
        waybar = "waybar";
        nvim = "nvim";
    };
in
{
    home.username = "ethang";
    home.homeDirectory = "/home/ethang";
    home.stateVersion = "25.05";

    fonts.fontconfig.enable = true;

    programs.git.enable = true;

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;


        oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "eastwood";
        }

        # Launch hyprland on login if we have a display
        profileExtra = ''
            if [-z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
                exec hyprland
            fi
        '';
        
        history.size = 10000;
    };

    # Loop over all defined config directories and create
    # symlinks to the .config directory in $HOME.
    xdg.configFile = builtins.mapAttrs
        (name: subpath: {
            source = create_symlink "${dotfiles}/${subpath}";
            recursive = true;
        })
        configs;


    home.packages = with pkgs; [
        nerd-fonts.fira-mono
        brave
        neovim
        ripgrep
        nodejs
        gcc
    ];
}
