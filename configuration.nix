# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:
let
  user = (import ./global-params.nix).user;
  system = (import ./global-params.nix).system;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home-manager.nix
    ];

  # Bootloader.
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ 
      "iommu=pt"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 4;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  # cachnix for hyprland
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  
  # periodically collect garbage to recover disk space
  nix.settings.auto-optimise-store = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # non-root qmk access
  hardware.keyboard.qmk.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Nguyen Phuc Nguyen";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # nix-ld to run unpackaged/arbitrary binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    icu
    libappindicator-gtk3
    libdrm
    libGL
    libglvnd
    libnotify
    libpulseaudio
    libunwind
    libusb1
    libuuid
    libxkbcommon
    libxml2
    glfw
    mesa
    nspr
    nss
    openssl
    pango
    pipewire
    systemd
    vulkan-loader
    zlib
  ];

  # GUI file manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.udisks2.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Power management
  services.upower = {
    enable = true;
    usePercentageForPolicy = true;
    percentageLow = 10;
    percentageCritical = 5;
    percentageAction = 4;
    criticalPowerAction = "PowerOff";
  };

  # Some udev rules
  services.udev.packages = with pkgs; [
    qmk-udev-rules
  ];

  # enable wake from sleep through usb devices
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0083", ATTR{power/wakeup}="enabled"
  '';

  boot.extraModprobeConfig = ''
    blacklist nouveau
    options nouveau modeset=0
    options nvidia-drm modeset=1
  '';
  boot.blacklistedKernelModules = [ "nouveau" ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Icky but let obsidian work
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nix-index
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    yazi
    wget
    lxqt.lxqt-policykit # default auth client for polkit
    papirus-icon-theme
    coreutils
    lshw
    powertop
    nvtop
    htop
    usbutils
    pciutils
    sway-audio-idle-inhibit

    glxinfo
    clinfo
    tomlplusplus
    pkg-configUpstream
    libnotify

    # display libraries
    libGL
    libglvnd
    glfw

    # graphics libraries
    pixman
    cairo
    pango
    mesa

    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
    libva
    libva-utils

    hyprland-protocols
    hyprlang
  ] ++ [
    inputs.wayland-pipewire-idle-inhibit.packages.x86_64-linux.wayland-pipewire-idle-inhibit
  ];
 
  # overlays
  nixpkgs.overlays = [
    (final: prev: { 
      # latest discord version
      discord = prev.discord.overrideAttrs (_: {
      	src = builtins.fetchTarball {
      	  url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "087p8z538cyfa9phd4nvzjrvx4s9952jz1azb2k8g6pggh1vxwm8";
      	};
      });

      # latest zoom version
      # zoom-us = prev.zoom-us.overrideAttrs (_: {
      #   version = "5.15.2.4260";
      #   src = prev.fetchurl {
      #     url = "https://zoom.us/client/5.15.2.4260/zoom_x86_64.pkg.tar.xz";
      #     hash = "sha256-R6M180Gcqu4yZC+CtWnixSkjPe8CvgoTPWSz7B6ZAlE=";
      #   };
      # });
    })
  ];

  # List of font
  fonts.packages = with pkgs; [
    jetbrains-mono
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" "NerdFontsSymbolsOnly"]; })
    (google-fonts.override { fonts = [ "ZenMaruGothic" ]; })
  ];

  # enable nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # make swaylock work
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  # hardware.cpu.amd.updateMicrocode = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      mesa.drivers
      rocmPackages.clr.icd
      amdvlk
      driversi686Linux.amdvlk
    ];
  };
  # use this to set opengl to amdgpu -- fixing alacritty slow startup time
  environment.sessionVariables = {
  #   "__EGL_VENDOR_LIBRARY_FILENAMES" = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib";
  };


  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
  };
  services.interception-tools = {
    enable = true;
    plugins = with pkgs; [
      interception-tools-plugins.caps2esc
    ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';  
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # default xdg portal behavior
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services.fwupd.enable = true; 

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
