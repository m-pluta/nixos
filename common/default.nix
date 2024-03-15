{ pkgs, ... }: {
  system.stateVersion = "23.11"; # Did you read the comment?

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.udev.packages = [pkgs.dolphinEmu];
  networking.hostName = "miikey-nixos";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
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

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    layout = "gb";
    xkbVariant = "";
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "miikey";

  };
  console.keyMap = "uk";
  services.printing.enable = true;

  services.mpd.enable = true;
  services.fstrim.enable = true;
  services.dbus.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  networking.firewall.enable = false;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      sandbox = true;
      trusted-users = [ "miikey" ];

      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://cache.ngi0.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    package = pkgs.nixVersions.stable;
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=2m
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  nixpkgs.config = { allowUnfree = true; };
  time.timeZone = "Europe/London";

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "miikey" ];

  programs.steam.enable = true;
  programs.zsh.enable = true;
  fonts = {
    packages = with pkgs; [ 
      nerdfonts 
      noto-fonts
      noto-fonts-cjk
    ];

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
      miikey = {
        isNormalUser = true;
        description = "Michal";
        initialPassword = "password";
        extraGroups = [ "networkmanager" "wheel" "video" ];
      };
    };
    defaultUserShell = pkgs.zsh;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    fuse
    unzip
    tree
    gparted
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
