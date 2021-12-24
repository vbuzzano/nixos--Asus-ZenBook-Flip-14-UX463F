#############################
## VIRTUALISATION / DOCKER ##
#############################
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    enableNvidia = true;
    listenOptions = [
      "/run/docker.sock"
    ];
    # Not compatible with swarm
    liveRestore = true;

    # Auto prune
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [
        # Remove all unused images not just dangling ones 
        # "--all"
        # Provide filter values (e.g. 'label=<key>=<value>')
        # "--filter"
        # Prune volumes
        # "--volumes"
        # Do not prompt for confirmation
        "--force"
      ];
    };
  };
}

