#############################
## PROGRAMS | SWAY         ##
#############################

{ config, pkgs, lib, ... }: {

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraOptions = [ "--my-next-gpu-wont-be-nvidia" ];
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    ];
  };

#  programs.sway = {
#    enable = true;
#    extraPackages = with pkgs; [
#      swaylock # lockscreen
#      swayidle
#      xwayland # for legacy apps
#      waybar # status bar
#      mako # notification daemon
#      kanshi # autorandr
#    ];
#  };

  programs.waybar.enable = true;

}
