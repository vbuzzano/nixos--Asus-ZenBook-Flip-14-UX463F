#############################
## SYSTEM FONTS            ##
#############################
{ pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    liberation_ttf
    fira-code
    roboto
    (nerdfonts.override { 
      fonts = [ 
        "Meslo"
        "FiraCode" 
        "DroidSansMono" 
      ]; 
    })
  ];
}

