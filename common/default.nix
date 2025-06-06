{ pkgs
, ...
}:

{
  system.stateVersion = "25.05";

  time.timeZone = "Europe/London";
  console.keyMap = "uk";
  i18n.defaultLocale = "en_GB.UTF-8";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    # enableAllFirmware = true;
    # graphics = {
    #   enable = true;
    #   extraPackages = with pkgs; [ intel-media-driver intel-ocl ];
    # };
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # zramSwap = {
  #   enable = true;
  #   algorithm = "lzo";
  #   memoryPercent = 30;
  # };

  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;
    earlyoom = {
      enable = true;
      enableNotifications = true;
    };
    cpupower-gui.enable = true;
    systembus-notify.enable = true;
    logrotate.enable = true;
    printing.enable = true;
    thermald.enable = true;
    libinput.enable = true;
    fstrim.enable = true;
    dbus.enable = true;
    fail2ban.enable = true;
    mullvad-vpn.enable = true;

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

    # desktopManager.plasma6.enable = true;
    # displayManager = {
    #   sddm.enable = true;
    #   sddm.wayland.enable = true;
    # };
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
    steam.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    starship = {
      enable = true;
      # settings = {
      #   add_newline = false;
      #   #battery.display.threshold = 90;
      #   directory.fish_style_pwd_dir_length = 3;
      #   format = "$directory $character";
      #   memory_usage.disabled = false;
      #   pijul_channel.disabled = false;
      #   right_format = "$all";
      #   time.disabled = false;
      #   typst.format = "(\\[[$symbol($version )]($style)\\])";
      #   vlang.disabled = true;
      #   direnv = {
      #     disabled = false;
      #     format = "(\\[[$symbol$loaded/$allowed]($style)\\])";
      #   };
      #   shell = {
      #     disabled = false;
      #     zsh_indicator = "";
      #     format = "(\\[[$indicator]($style)\\])";
      #   };
      #   os = {
      #     disabled = false;
      #     symbols.NixOS = "";
      #     format = "(\\[[$symbol]($style)\\])";
      #   };
      # };
      # presets = [
      #   "nerd-font-symbols"
      #   #"no-empty-icons"
      #   "bracketed-segments"
      # ];
    };

    nh = {
      enable = true;
      # flake = "/home/mikey/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep-since 1M --keep 10 --nogcroots";
      };
    };
  };

  environment = {
    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
    systemPackages = with pkgs; [
      vim
      fd
      ripgrep
      git
      unzip
      wget
      gparted
      tree
      btop
      htop
      haruna
      hardinfo2
    ];
  };

  networking = {
    hostName = "mikebook";
    hostId = "01afcada";
    firewall.enable = true;
    nftables.enable = true;
    networkmanager.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      iosevka
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "full";
        autohint = true;
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
  };

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
