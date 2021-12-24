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

  environment.systemPackages = with pkgs; [ 
    pciutils inxi glxinfo lm_sensors
    smartmontools
  ];
}
