#############################
## Boot                    ##
#############################
{
  ## Loader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  ### Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
}
