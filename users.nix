###################
## Users          #
###################
{ pkgs, ... }:

{
  users = {
    groups.plugdev = {};

    users.vincent = {
      uid = 1000;
      name = "vincent";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    extraUsers.vincent = {
      extraGroups = [ 
        "networkmanager" "audio" "video" "plugdev" "docker" 
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [ 
      ];
    };   
  };

#  home-manager.users.vincent = { pkgs, ... }: {
#    home.packages = [
#      pkgs.atool
#      pkgs.httpie
#      pkgs.micro
#      pkgs.speedtest-cli
#    ];
#    programs.bash.enable = true;
#    #programs.bash.zsh = true;
#  };
}
