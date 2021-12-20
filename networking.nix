###################
## Networking     #
###################
{
  networking.hostName = "zbf14"; # Define your hostname.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  ### The global useDHCP flag is deprecated, therefore explicitly set to false here.
  ### Per-interface useDHCP will be mandatory in the future, so this generated config
  ### replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;

  ## Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ###################
  ## Firewall       #
  ###################
  ## Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  ## Or disable the firewall altogether.
  networking.firewall.enable = true;
}
