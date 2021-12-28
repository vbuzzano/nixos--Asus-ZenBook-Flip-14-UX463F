#############################
## Boot & Kernel           ##
#############################
{ pkgs, ... }:

let

  grub-theme-dedsec-spyware = import ./grub-theme-dedsec-spyware.nix;
  
in {
  ## Loader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  ### Grub
  boot.loader.grub = {
      enable = false;
      version = 2;
      efiSupport = true;
      # despite what the configuration.nix manpage seems to indicate,
      # as of release 17.09, setting device to "nodev" will still call
      # `grub-install` if efiSupport is true
      # (the devices list is not used by the EFI grub install,
      # but must be set to some value in order to pass an assert in grub.nix)
      devices = [ "nodev" ];
      useOSProber = true;

      theme = "${grub-theme-dedsec-spyware}";

      ## set $FS_UUID to the UUID of the EFI partition
      #extraEntries = ''
      #  menuentry "Windows" {
      #    insmod part_gpt
      #    insmod fat
      #    insmod search_fs_uuid
      #    insmod chain
      #    search --fs-uuid --set=root $FS_UUID
      #    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      #  }
      #'';
    };

}
