{
  config,
  pkgs,
  inputs,
  ...
}:

{
  system = {
    stateVersion = "24.05";
    activationScripts.binbash = {
      deps = [ "binsh" ];
      text = ''
        ln -sf /bin/sh /bin/bash
      '';
    };
  };

  time.timeZone = "Europe/London";

  console.keyMap = "uk";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services = {
    printing.enable = true;
    auto-cpufreq.enable = true;
    thermald.enable = true;
    libinput.enable = true;
    fstrim.enable = true;
    dbus.enable = true;

    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
        START_CHARGE_THRESH_BAT0 = 80;
        STOP_CHARGE_THRESH_BAT0 = 90;
        RUNTIME_PM_ON_BAT = "auto";
      };
    };

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      xkb = {
        layout = "gb";
      };
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  programs = {
    firefox.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment = {
    variables = {
      EDITOR = "lvim";
      VISUAL = "lvim";
    };

    systemPackages = with pkgs; [
      vim
      neovim
      lunarvim
      fd
      ripgrep
      wget
      gparted
      tree
    ];
  };

  networking = {
    hostName = "mikebook";
    hostId = "01afcada";
    firewall.enable = true;
    networkmanager.enable = true;
  };

  nix = {
    settings = {
      trusted-users = [ "mikey" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      sandbox = true;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
    };

    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    # };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    package = pkgs.nixVersions.stable;
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # fonts = {
  #   packages = with pkgs; [ nerdfonts ];
  # };

  users = {
    users = {
      mikey = {
        isNormalUser = true;
        description = "Michal Pluta";
        initialPassword = "password";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
    defaultUserShell = pkgs.bash;
  };
}
