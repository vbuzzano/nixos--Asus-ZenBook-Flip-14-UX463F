###################
## HARDWARES      #
###################
{ pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./hardware-nvidia.nix
    ./hardware-audio.nix
    ./hardware-ledger.nix
  ];

  environment.systemPackages = with pkgs; [ pciutils inxi glxinfo ];
}
