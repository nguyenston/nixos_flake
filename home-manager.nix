{config, pkgs, lib, home-manager, ...}: 

let
  user = (import ./global-params.nix).user;

  dotfiles_directories = with builtins; attrNames (readDir ./dotfiles);
  import_dir = dir: import (./. + ("/dotfiles/" + dir));
  merge_sets = list: lib.attrsets.foldAttrs (item: acc: item) 0 list;
  dotfiles = with builtins; merge_sets (map import_dir dotfiles_directories);
in
{
  home-manager.users.${user} = {
    programs.home-manager.enable = true;

    home.username = "${user}";
    home.homeDirectory = "/home/${user}";
    # userspace packages
    home.packages = with pkgs; [
      # hyprland stuff
      alacritty # terminal
      rofi-wayland # app launcher
      swaylock
      swayidle
      pavucontrol # audio control panel
      eww-wayland # bars and widgets
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard
      wlogout # logout menu
      socat # socket stuff
      wpaperd
      
      # dependencies/utils
      libnotify
      tmux
      file
      ripgrep
      lazygit
      gdu
      bottom
      nodejs
      unzip
      zip
      pulseaudio
      brightnessctl
      dos2unix
      coreutils
      jq
      killall
      libinput
      (callPackage ./derivations/hyprpicker.nix {})

      # fonts
      jetbrains-mono
      nerdfonts

      # applications
      firefox
      discord
      grive2
      libsForQt5.okular
      gnome-text-editor
      
      # programming languages
      git
      rustup
      julia
      gcc
      cmake

      (python3.withPackages (p: with p; [
        magic
        numpy
        docopt
        pandas
        distro
        ruamel-yaml
        toml
        requests
        packaging
        jinja2 
      ]))
    ];

    # dotfiles
    home.file = dotfiles;

    # dunst - notification daemon
    services.dunst.enable = true;
    home.stateVersion = "22.11";
  };
}
