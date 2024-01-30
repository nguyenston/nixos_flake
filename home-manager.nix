{config, pkgs, lib, home-manager, ...}: 

let
  user = (import ./global-params.nix).user;

  dotfiles_directories = with builtins; attrNames (readDir ./dotfiles);
  import_dir = dir: import (./. + ("/dotfiles/" + dir));
  merge_sets = list: lib.attrsets.foldAttrs (item: acc: item) 0 list;
  dotfiles = merge_sets (map import_dir dotfiles_directories);

  desktop_entries_directories = with builtins; attrNames (readDir ./desktop-entries);
  desktop_entries = merge_sets (map import_dir desktop_entries_directories);
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
      obs-studio
      htop
      
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
      # (callPackage ./derivations/hyprpicker {})
      viewnior
      qmk
      fd
      sshfs
      pandoc
      swayidle

      # applications
      firefox
      webcord
      grive2
      libsForQt5.okular
      gnome-text-editor
      masterpdfeditor
      zathura # vim-based pdf viewer
      xarchiver
      vlc
      zoom-us
      obsidian
      rclone
      zotero
      
      # programming languages
      git
      rustup
      julia
      gcc
      clang-tools
      bear
      cmake
      lua
      gnumake
      texliveFull
      pplatex
      nodejs
      nodePackages.npm
      nodePackages.pyright

      # lsp stuff
      lua-language-server
      nil # nix language server
      ## rust-analyzer is included in rustup
      stylua
      shfmt # shell format
      marksman # markdown
      ruff # linter for python3
      ruff-lsp # lsp for python3


      (python3.withPackages (p: with p; [
        virtualenv
        pip
        setuptools
        wheel

        argcomplete
        qmk
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
        scikit-learn
        tkinter
      ]))
    ];



    xdg.desktopEntries = desktop_entries;
    # dotfiles
    home.file = dotfiles;

    # dunst - notification daemon
    services.dunst.enable = true;
    home.stateVersion = "22.11";
  };
}
