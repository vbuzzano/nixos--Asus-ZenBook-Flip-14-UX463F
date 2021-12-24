##################################
## HARDWARE | AUDIO TRADITIONAL ##
##################################
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pavucontrol
    jack_capture
    qjackctl
  ];

  services.jack = {
    jackd = {
      enable = true;
      # To obtain a valid device argument run `aplay -l`
      #     - `hw` prefix should be always there
      #     - `1` is a card number
      #     - `0` is a device number
      # Example (card 1, device 0)
      # card 1: USB [Scarlett 2i2 USB], device 0: USB Audio [USB Audio]
      #   Subdevices: 0/1
      #   Subdevice #0: subdevice #0
      extraOptions = [ "-dalsa" "--device" "hw:1,0" ];
      package = pkgs.jack2Full;
    };
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    support32Bit = true;
  };

  # NOTE: not needed with musnix which takes care of this implicitely
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
  ];
}
