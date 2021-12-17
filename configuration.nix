# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./nvidia-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.enableGnomeExtensions = true;
  
  ## Kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  # boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [ "binder-linux" ];
  #boot.extraModprobeConfig = ''
  #   options binder_linux devices=binder,hwbinder,vndbinder
  #'';

  ## Boot Loader
  ### Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  ### Grub
  # boot.loader.grub.version = 2;
  # boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  ###################
  ## System Options #
  ###################
  ### Setup time
  time.timeZone = "Europe/Zurich";
  time.hardwareClockInLocalTime = true;

  ### Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr_CH-latin1";
  };

  ### Setup default fonts
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

  ###################
  ## Audio          #
  ###################
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  ### Explicit PulseAudio support in applications
  # nixpkgs.config.pulseaudio = true;

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
    # xkbModel = "fr"; ??
    # xkbOptions = "eurosign:e"; ??

    ### Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  ################################
  ### GNOME Desktop Environment. #
  ################################
  services.xserver.desktopManager.gnome.enable = true;
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

  ###################
  ## Environment    #
  ###################
  ## List packages installed in system profile. To search, run:
  ## $ nix search wget
  environment = {

    ### Additional Packages
    systemPackages = with pkgs; [ 
      htop dig wget git
      pciutils inxi glxinfo
      firefox-wayland

      #### Gnome
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
      ##### Add some extensions
      gnomeExtensions.appindicator
      gnomeExtensions.hibernate-status-button
      gnomeExtensions.dash-to-dock
      gnomeExtensions.bing-wallpaper-changer
      ##### Gnome themes
      dracula-theme
      arc-theme
      yaru-theme
      pop-gtk-theme
      #### Icon themes
      arc-icon-theme
      moka-icon-theme
      papirus-icon-theme
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
    gnome.excludePackages = with pkgs; [ epiphany ];
  };


  ###################
  ## Virtualisation #
  ###################
  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;
  # virtualisation.libvirtd.enable = true;

  ###################
  ## Users          #
  ###################

  users = {
    ### Define a user account. Don't forget to set a password with ‘passwd’.
    users.vincent = {
      uid = 1000;
      name = "vincent";
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # wheel will enable ‘sudo’ for the user.
    };

    extraUsers.vincent = {
      extraGroups = [ 
        "networkmanager" "audio" "video" "docker" 
      ];
      shell = pkgs.zsh;
      # packages = with pkgs; [ vlc bitwarden keepassxc ];
    };   
  };

  ###################
  ## Networking     #
  ###################
  networking.hostName = "zbf14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  ### The global useDHCP flag is deprecated, therefore explicitly set to false here.
  ### Per-interface useDHCP will be mandatory in the future, so this generated config
  ### replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;
  ## Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ###################
  ## Firewall       #
  ###################
  ## Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  ## Or disable the firewall altogether.
  networking.firewall.enable = true;

  ###################
  ## NixOS Release  #
  ###################
  ## This value determines the NixOS release from which the default
  ## settings for stateful data, like file locations and database versions
  ## on your system were taken. It‘s perfectly fine and recommended to leave
  ## this value at the release version of the first install of this system.
  ## Before changing this value read the documentation for this option
  ## (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

