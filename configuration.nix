# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware
      ./boot
      ./networking.nix
      ./system
      ./virt
      ./users
      ./programs
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.firefox.enableGnomeExtensions = true;

  # Kernel options
  #boot.kernelPackages = pkgs.linuxPackages_xanmod;
  #boot.kernelModules = [ "binder-linux" ];

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


  ###################
  ## Environment    #
  ###################
  ## List packages installed in system profile. To search, run:
  ## $ nix search wget
  environment = {

    ### Additional Packages
    systemPackages = with pkgs; [ 
      htop killall dig wget git micro 
      wl-clipboard xclip
      libgtop

      #ledger-udev-rules
      #tpmmanager tmuxPlugins.sensible 
      #tmuxPlugins.resurrect tmuxPlugins.dracula
      #tmuxPlugins.yank tmuxPlugins.jump
      #tmuxPlugins.sidebar tmux-mem-cpu-load
      # tmuxPlugins.ctrlw 

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

  ###################
  ## Virtualisation #
  ###################
  #virtualisation.waydroid.enable = true;
  # virtualisation.libvirtd.enable = true;

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

