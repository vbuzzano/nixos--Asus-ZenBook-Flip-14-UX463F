{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  imports =
    [ 
      ./hardware-configuration.nix
      ./users
      ./programs
    ];

  nixpkgs.config.allowUnfree = true;

  #############################
  ## Kernel Config           ##
  #############################
  #boot.kernelPackages = pkgs.linuxPackages_xanmod;
  #boot.kernelModules = [ "binder-linux" ];

  #############################
  ## Boot Config             ##
  #############################
  ## Loader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  ### Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  boot.cleanTmpDir = true;


  #############################
  ## Nvidia GPU              ##
  #############################
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    prime = {
      offload.enable = true;
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };


  #############################
  ## AUDIO                   ##
  #############################
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    #socketActivation = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # rtkit is optional but recommended
  security.rtkit.enable = true;


  ##################################
  ## HARDWARE | LEDGER            ##
  ##################################
  hardware.ledger.enable = true;


  #############################
  ## Locale Options          ##
  #############################
  # Setup time
  time = {
    timeZone = "Europe/Zurich";
    # fix clock for dualboot with windows
    hardwareClockInLocalTime = true;
  };

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #i18n.supportedLocales = [ "fr_CH.UTF-8/UTF-8" ];

  # Console options 
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr_CH-latin1";
  };

  services.cron = {
    enable = true;
  # systemCronJobs = [
  #    "0 */1 * * *  root     command
  # ];
  };


  #############################
  ## SYSTEM FONTS            ##
  #############################
  fonts.fonts = with pkgs; [
    liberation_ttf
    fira-code
    roboto
    (nerdfonts.override { 
      fonts = [ 
        "Meslo"
        "FiraCode" 
        "DroidSansMono" 
      ]; 
    })
  ];


  ##########################
  ## X11 windowing system. #
  ##########################
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    #videoDrivers = [ "nouveau" ];

    ### Configure keymap in X11
    layout = "ch";
    xkbVariant = "fr";
    xkbModel = "pc105";
    # xkbOptions = "eurosign:e"; ??

    ### Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  ################################
  ### GNOME Desktop Environment. #
  ################################
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
    nvidiaWayland = true;
  };
  #### Enable Chrome Gnome Shell
  services.gnome.chrome-gnome-shell.enable = true;
  #### set default qt5 style
  qt5.style = "adwaita-dark";

  #############################
  ## CUPS to print documents. #
  #############################
  services.printing.enable = true;

  #############################
  ## Programs - SUID wrappers #
  #############################
  programs.dconf.enable = true;
  programs.steam.enable = true;

  programs.zsh = {
    enable = true;
    # ohMyZsh = {
    #   enable = true;
    #   plugins = [ "git" "man" ];

    #   theme = "random";
    #   custom = "~/.oh-my-ssh";
    # };
    # promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme"`
  };

  nixpkgs.config.firefox.enableGnomeExtensions = true;

  #############################
  ## Environment             ##
  #############################
  ## List packages installed in system profile. To search, run:
  ## $ nix search wget
  environment = {

    ### Additional Packages
    systemPackages = with pkgs; [ 
      #### sys
      htop killall dig wget git micro 
      wl-clipboard xclip
      libgtop

      #### hardwares tools
      pciutils inxi glxinfo 
      lm_sensors smartmontools

      #### audio
      qjackctl pavucontrol alsa-utils
      # need for pipewire ' don't know why
      # cf: https://www.reddit.com/r/NixOS/comments/oaj0of/sound_not_working_alsa_connection_refused/h3jowwr/
      sof-firmware

      ### gpu
      nvidia-offload

      ### desktop
      firefox-wayland
      lollypop

      #### Gnome
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
      ##### Add some extensions
      gnomeExtensions.appindicator
      gnomeExtensions.volume-mixer
      gnomeExtensions.hibernate-status-button
      gnomeExtensions.dash-to-dock
      gnomeExtensions.bing-wallpaper-changer
      gnomeExtensions.vitals
      ##### Gnome themes
      dracula-theme
      arc-theme
      yaru-theme
      pop-gtk-theme
      #### Icon themes
      arc-icon-theme
      pop-icon-theme
    ];

    ### Enable Shells
    shells = [
      pkgs.bashInteractive
      pkgs.zsh
    ];

    ## Exclude some gnome packages
    ## > gnome-photos gnome.gnome-music gnome.gnome-terminal gnome.gedit 
    ##   evince gnome.gnome-characters gnome.totem pkgs.gnome-tour
    gnome.excludePackages = with pkgs; [
      epiphany
      gnome.gnome-music
    ];
  };

  services.flatpak.enable = true;


  #############################
  ## Virtualisation          ##
  #############################
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    enableNvidia = true;
    listenOptions = [
      "/run/docker.sock"
    ];
    # Not compatible with swarm
    liveRestore = true;

    # Auto prune
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [
        # Remove all unused images not just dangling ones 
        # "--all"
        # Provide filter values (e.g. 'label=<key>=<value>')
        # "--filter"
        # Prune volumes
        # "--volumes"
        # Do not prompt for confirmation
        "--force"
      ];
    };
  };

  # virtualisation.waydroid.enable = true;
  # virtualisation.libvirtd.enable = true;


  #############################
  ## Networking              ##
  #############################
  networking.hostName = "zbf14"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;


  #############################
  ## Firewall                ##
  #############################
  networking.firewall.enable = true;


  #############################
  ## USERS                   ##
  #############################
  users.groups.plugdev = {};

  users.users.vincent = {
    uid = 1000;
    name = "vincent";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.extraUsers.vincent = {
    extraGroups = [ 
      "networkmanager" "disk" "plugdev" "docker" 
      "audio" "video"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ 
    ];
  };   


  #############################
  ## NixOS Release           ##
  #############################
  ## This value determines the NixOS release from which the default
  ## settings for stateful data, like file locations and database versions
  ## on your system were taken. It‘s perfectly fine and recommended to leave
  ## this value at the release version of the first install of this system.
  ## Before changing this value read the documentation for this option
  ## (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

