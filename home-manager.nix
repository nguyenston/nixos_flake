{config, pkgs, lib, inputs, ...}: 

let
  user = (import ./global-params.nix).user;

  dotfiles_directories = with builtins; attrNames (readDir ./dotfiles);
  import_dir = root: (dir: import (./. + (root + dir)));
  merge_sets = list: lib.attrsets.foldAttrs (item: acc: item) 0 list;
  dotfiles = merge_sets (map (import_dir "/dotfiles/") dotfiles_directories);

  desktop_entries_directories = with builtins; attrNames (readDir ./desktop-entries);
  desktop_entries = merge_sets (map (import_dir "/desktop-entries/") desktop_entries_directories);
in
{
  home-manager.users.${user} = {
    imports = [ inputs.ags.homeManagerModules.default ];
    programs.home-manager.enable = true;

    # widget utilities similar to eww
    programs.ags = {
      enable = true;
      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };

    home.username = "${user}";
    home.homeDirectory = "/home/${user}";
    # userspace packages
    home.packages = with pkgs; [
      # hyprland stuff
      alacritty # terminal
      wezterm
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
      
      # dependencies/utils
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
      ueberzugpp
      # (callPackage ./derivations/hyprpicker {})
      viewnior
      qmk
      fd
      sshfs
      pandoc
      swayidle
      ninja
      gdb
      meson

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
      julia-bin
      gcc
      clang-tools_17
      bear
      cmake
      lua
      gnumake
      texliveFull
      pplatex
      nodejs
      nodePackages.npm
      nodePackages.pyright
      typescript
      nodePackages.typescript-language-server

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
        jupyterlab
      ]))
    ] ++ [
      inputs.hyprpicker.packages.x86_64-linux.hyprpicker
    ];



    xdg.desktopEntries = desktop_entries;
    # dotfiles
    home.file = dotfiles;

    # dunst - notification daemon
    services.dunst.enable = true;
    home.stateVersion = "22.11";
  };
}
