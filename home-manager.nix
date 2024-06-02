{config, pkgs, lib, inputs, ...}: 

let
  global_params = import ./global-params.nix;
  user = global_params.user;

  dotfiles_directories = with builtins; attrNames (readDir ./dotfiles);
  import_dir = root: (dir: import (./. + (root + dir)));
  merge_sets = list: lib.attrsets.foldAttrs (item: acc: item) 0 list;
  dotfiles = merge_sets (map (import_dir "/dotfiles/") dotfiles_directories);

  desktop_entries_directories = with builtins; attrNames (readDir ./desktop-entries);
  desktop_entries = merge_sets (map (import_dir "/desktop-entries/") desktop_entries_directories);
  stable_pkgs = import inputs.nixpkgs_stable {
    system = pkgs.system;
    config.allowUfree = true;
  };
in
{
  home-manager.users.${user} = {
    imports = [
      # inputs.nur.hmModules.nur
      inputs.ags.homeManagerModules.default
      # inputs.hyprlock.homeManagerModules.default
    ];
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

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland.overrideAttrs (prev: {
        patches = (prev.patches or []) ++ [ ];
      });
      xwayland = {
        enable = true;
      };
      plugins = [
      ];
      extraConfig = builtins.readFile ./dotfiles/hypr/hyprland.conf;
    };
    programs.hyprlock.enable = true;

    home.username = "${user}";
    home.homeDirectory = "/home/${user}";
    # userspace packages
    home.packages = with pkgs; [
      # hyprland stuff
      alacritty # terminal
      wezterm
      rofi-wayland # app launcher
      pavucontrol # audio control panel
      eww # bars and widgets
      grim # screenshot functionality
      slurp # screenshot functionality
      wf-recorder
      wl-clipboard
      wlogout # logout menu
      socat # socket stuff
      wpaperd
      obs-studio
      
      # dependencies/utils
      unrar
      zoxide # smarter and faster cd
      fzf # fuzzy finder
      networkmanagerapplet
      bun # javascript runtime, bundler, transpiler and package manager
      sassc
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      yazi # terminal file explorer
      unar # archive preview
      poppler # pdf preview
      file
      zellij # terminal mux
      ripgrep
      lazygit
      wget
      gdu
      bottom
      nodejs
      unzip
      zip
      brightnessctl
      dos2unix
      coreutils
      jq
      killall
      libinput
      ueberzugpp
      loupe # image viewer
      qmk
      fd
      sshfs
      pandoc
      swayidle
      ninja
      gdb
      meson
      hyprpicker
      hyprpaper

      # nix-based developer environment
      devenv
      direnv

      # applications
      cmatrix # eyecandy terminal stuff
      firefox-beta
      darktable # photo editing
      # config.nur.repos.clefru.ib-tws
      # stable_pkgs.librewolf
      webcord
      telegram-desktop
      grive2
      libsForQt5.okular
      gnome-text-editor
      masterpdfeditor
      zathura # vim-based pdf viewer
      xarchiver
      mpv
      haruna
      gnome.sushi
      zoom-us
      obsidian
      rclone
      # zotero
      zotero_7
      realvnc-vnc-viewer

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

      (rWrapper.override {
        packages = with rPackages; [
          languageserver
          devtools
          ggplot2
          dplyr
          xts
          ggseqlogo
          BiocManager
          shinydashboard
          shinyjs
          musicatk
        ];
      })

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
      # inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
      inputs.hypridle.packages.${pkgs.system}.hypridle
      (pkgs.buildEnv {
        name = "custom-scripts";
        paths = [
          ./scripts
        ];
      })
    ];
    
    # Theming
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 10;
    };

    gtk = {
      enable = true;

      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 10;
      };

      theme = {
        package = pkgs.colloid-gtk-theme;
        name = "Colloid-Dark";
      };

      iconTheme = {
        package = pkgs.colloid-icon-theme;
        name = "Colloid";
      };
    };

    # custom desktop entries
    xdg.desktopEntries = desktop_entries;

    # .config directory dotfiles
    home.file = dotfiles;

    # dunst - notification daemon
    services.dunst.enable = true;
    home.stateVersion = "22.11";
  };
}
