#############################
## BOOT                    ##
#############################
{
  imports = [ ./boot.nix ];

  ## Clean tmp dir
  boot.cleanTmpDir = true;
}

