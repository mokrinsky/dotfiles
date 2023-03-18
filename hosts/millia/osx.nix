{config, ...}: {
  home-manager.users.${config.username}.targets.darwin.defaults = {
    NSGlobalDomain = {
      AppleLanguages = ["en-GB" "en-RU" "ru-RU" "en" "it"];
      AppleLocale = "en_RU"; # dd/mm/yyyy - 3.14 - 10,000 - week starts on Monday
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = true;
      AppleTemperatureUnit = "Celsius";
      AppleActionOnDoubleClick = "Maximize";
      AppleAquaColorVariant = 1;
      AppleInterfaceStyle = "Dark";
      AppleHighlightColor = "0.115673 0.118837 0.182377 Other";
      AppleMiniaturizeOnDoubleClick = 0;
      ApplePressAndHoldEnabled = 0;
      AppleReduceDesktopTinting = 0;
      _HIHideMenuBar = false;
      "com.apple.mouse.scaling" = 1;
      "com.apple.sound.beep.feedback" = 1;
      "com.apple.sound.beep.flash" = 0;
      "com.apple.sound.uiaudio.enabled" = 1;
      "com.apple.springing.delay" = "0.5";
      "com.apple.springing.enabled" = 1;
      "com.apple.swipescrolldirection" = 1;
      "com.apple.trackpad.forceClick" = 1;
    };
    com.apple.desktopservices = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    com.apple.dock = {
      autohide = true;
      largesize = false;
      magnification = false;
      mineffect = "genie";
      orientation = "right";
      tilesize = 45;
    };
    com.apple.TimeMachine = {
      DoNotOfferNewDisksForBackup = true;
    };
    com.apple.finder = {
      DisableAllAnimations = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = false;
      ShowRemovableMediaOnDesktop = true;
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "Nlsv";
    };
  };
}
