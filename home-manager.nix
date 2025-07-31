{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  global_params = import ./global-params.nix;
  user = global_params.user;

  dotfiles_directories = with builtins; attrNames (readDir ./dotfiles);
  import_dir = root: (dir: import (./. + (root + dir)));
  merge_sets = list: lib.attrsets.foldAttrs (item: acc: item) 0 list;
  dotfiles = merge_sets (map (import_dir "/dotfiles/") dotfiles_directories);

  desktop_entries_directories = with builtins; attrNames (readDir ./desktop-entries);
  desktop_entries = merge_sets (map (import_dir "/desktop-entries/") desktop_entries_directories);
  # stable_pkgs = import inputs.nixpkgs_stable {
  #   system = pkgs.system;
  #   config.allowUfree = true;
  # };
in
{
  home-manager.users.${user} = {
    imports = [
      inputs.niri.homeModules.niri
    ];
    programs.home-manager.enable = true;

    programs.niri = {
      enable = true;
      package = inputs.niri.packages.${pkgs.system}.niri-unstable;
    };

    # wayland.windowManager.hyprland = {
    #   enable = false;
    #   package = inputs.hyprland.packages.${pkgs.system}.hyprland.overrideAttrs (prev: {
    #     patches = (prev.patches or []) ++ [ ];
    #   });
    #   xwayland.enable = true;
    #   plugins = [
    #   ];
    #   extraConfig = builtins.readFile ./dotfiles/hypr/hyprland.conf;
    # };
    # programs.hyprlock.enable = false;

    home.username = "${user}";
    home.homeDirectory = "/home/${user}";
    # userspace packages
    home.packages =
      with pkgs;
      [
        # inputs.agsbar.packages.${pkgs.system}.default
        inputs.ags.packages.${system}.agsFull
        # hyprland stuff
        maxfetch # fetch program
        # alacritty # terminal
        kitty
        inputs.ghostty.packages.${pkgs.system}.default
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
        xwayland-satellite
        obs-studio

        # dependencies/utils
        unrar
        csvlens # cli csv viewer
        zoxide # smarter and faster cd
        fzf # fuzzy finder
        bun # javascript runtime, bundler, transpiler and package manager
        sassc # sass compiler
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        yazi # terminal file explorer
        unar # archive preview
        poppler # pdf preview
        file
        zellij # terminal mux
        ripgrep
        lazygit
        wget
        gdu # disk usage tool
        bottom
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
        exiftool
        mediainfo
        qmk
        fd
        sshfs
        pandoc
        # ninja # collision with python 3.12.9
        gdb
        meson
        hyprpicker
        hyprpaper
        hyprsunset
        xorg.xlsclients
        swayidle

        # nix-based developer environment
        devenv
        direnv

        # applications
        cmatrix # eyecandy terminal stuff
        firefox-beta
        # darktable # photo editing temporarily disable due to build failure
        imagemagick
        rawtherapee # photo editing
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
        zoom-us
        obsidian
        rclone
        zotero
        fragments # torrent client
        mokuro # selectable text manga generator
        openconnect # BU VPN
        doublecmd
        calibre # ebook manager
        realvnc-vnc-viewer
        synergy
        gparted
        waybar
        localsend # p2p file share
        krita # drawing program

        # programming languages
        micromamba # conda but newer
        git
        julia-bin
        gcc
        clang-tools_17
        bear
        cmake
        lua
        gnumake
        texliveFull
        pplatex
        # nodejs # included in npm
        nodePackages.npm
        typescript
        nodePackages.typescript-language-server

        # lsp stuff
        lua-language-server
        nil # nix language server
        stylua
        shfmt # shell format
        marksman # markdown
        pyright
        basedpyright
        pylyzer
        ruff # linter for python3
        texlab # lsp for latex

        # (rWrapper.override {
        #   packages = with rPackages; [
        #     languageserver
        #     devtools
        #     ggplot2
        #     dplyr
        #     xts
        #     ggseqlogo
        #     BiocManager
        #     shinydashboard
        #     shinyjs
        #     # musicatk # dependency error
        #   ];
        # })

        (fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
        rust-analyzer-nightly

        (python3.withPackages (
          p: with p; [
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
            manga-ocr
          ]
        ))
      ]
      ++ [
        # inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
        # inputs.hypridle.packages.${pkgs.system}.hypridle
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
      size = 16;
    };

    gtk = {
      enable = true;

      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
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
    # services.dunst.enable = true; using astal notifd
    home.stateVersion = "22.11";
  };
}
