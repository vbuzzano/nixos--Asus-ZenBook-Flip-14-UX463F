#############################
## HARDWARE                ##
#############################
{ pkgs, ... }:

{
  imports = [ 
    ../hardware-configuration.nix
    ./nvidia.nix
    ./audio.nix
    ./ledger.nix
  ];

#  sound.enable = true;
#  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [ 
    pciutils inxi glxinfo lm_sensors
    smartmontools
    lsof
  ];
}
