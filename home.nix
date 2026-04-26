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

    home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "WhiteSur-cursors";
        package = pkgs.whitesur-cursors;
        size = 24;
    };
    
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "EthanG78";
                email = "ethangarnier78@gmail.com";
            };
            init.defaultBranch = "main";
        };
    };

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "eastwood";
        };

        # Launch hyprland on login if we have a display
        profileExtra = ''
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
                exec start-hyprland
            fi
        '';
        
        history.size = 10000;
    };

    # Loop over all defined config directories and create
    # symlinks to the .config directory in $HOME.
    xdg.configFile = builtins.mapAttrs (name: subpath: {
            source = create_symlink "${dotfiles}/${subpath}";
            recursive = true;
        }) configs;


    home.packages = with pkgs; [
        nerd-fonts.fira-mono
        whitesur-cursors
        brave
        neovim
        ripgrep
        python3
        nodejs
        gcc
    ];
}
