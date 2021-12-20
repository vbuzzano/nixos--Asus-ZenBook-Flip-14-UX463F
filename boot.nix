###################
## Boot & Kernel  #
###################
{ pkgs, ... }:

{
  # Kernel options
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  boot.kernelModules = [ "binder-linux" ];

  ## Loader
  ### Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  ### Grub
  # boot.loader.grub.version = 2;
  # boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
}
