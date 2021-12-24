#############################
## User > vincent          ##
#############################
{ pkgs, ... }:

{
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
}
