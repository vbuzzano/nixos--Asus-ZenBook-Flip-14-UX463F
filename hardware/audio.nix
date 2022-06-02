###############################
## HARDWARE | AUDIO PIPEWIRE ##
###############################
{ pkgs, ... }:

{
  # Remove sound.enable or turn it off if you had it set previously, 
  # it seems to cause conflicts with pipewire
  #sound.enable = false;
  hardware.pulseaudio.enable = false;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    socketActivation = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
    
  services.pipewire = {
    # Some useful knobs if you want to finetune or debug your setup: 
    config.pipewire = {
      "context.properties" = {
        "core.daemon" = true;
        "core.name" = "pipewire-0";
        #"log.level" = 2; # https://docs.pipewire.org/page_daemon.html
        "link.max-buffers" = 16;
        "default.clock.allowed-rates" = [ 44100 48000 ];
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 4096; # 8192
        "vm.overrides" = {
          "default.clock.min-quantum" = 1024;
        };
      };
    };

    #media-session.config.alsa-monitor.rules = [
    #  { 
    #    "actions" = {
    #      "update-props" = {
    #        "api.acp.auto-port" = false;
    #        "api.acp.auto-profile" = false;
    #        "api.alsa.use-acp" = true;
    #        "api.alsa.headroom" = 0;
    #        "api.alsa.period-size" = 256;
    #      };
    #    };
    #    "matches" = [
    #      {
    #        "device.name" = "~alsa_card.*";
    #      }
    #    ];
    #  }
    #  {
    #    "actions" = {
    #      "update-props" = {
    #        "node.pause-on-idle" = false;
    #      };
    #    };
    #    "matches" = [
    #      {
    #        "node.name" = "~alsa_input.*";
    #      }
    #      {
    #        "node.name" = "~alsa_output.*";
    #      }
    #    ];
    #  }
    #];

  };
#  service.pipewire = 
#    media-session.config.bluez-monitor.rules = [
#      {
#        # Matches all cards
#        matches = [ { "device.name" = "~bluez_card.*"; } ];
#        actions = {
#          "update-props" = {
#            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
#            # mSBC is not expected to work on all headset + adapter combinations.
#            "bluez5.msbc-support" = true;
#            # SBC-XQ is not expected to work on all headset + adapter combinations.
#            "bluez5.sbc-xq-support" = true;
#          };
#        };
#      }
#      {
#        matches = [
#          # Matches all sources
#          { "node.name" = "~bluez_input.*"; }
#          # Matches all outputs
#          { "node.name" = "~bluez_output.*"; }
#        ];
#        actions = {
#          "node.pause-on-idle" = false;
#        };
#      }
#    ];
#  };

  environment.systemPackages = with pkgs; [ 
    qjackctl
    pavucontrol
    alsa-utils
    # need for pipewire ' don't know why
    # cf: https://www.reddit.com/r/NixOS/comments/oaj0of/sound_not_working_alsa_connection_refused/h3jowwr/
    sof-firmware
  ];
}
