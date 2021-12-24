#############################
## Locale Options          ##
#############################
{
  # Setup time
  time = {
    timeZone = "Europe/Zurich";
    # fix clock for dualboot with windows
    hardwareClockInLocalTime = true;
  };

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #i18n.supportedLocales = [ "fr_CH.UTF-8/UTF-8" ];

  # Console options 
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr_CH-latin1";
  };
}
