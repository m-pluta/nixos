{ inputs, config, lib, ... }: {
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mkForce (lib.mapAttrs (_: value: { flake = value; }) inputs);
    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      trusted-users = [ "mikey" ];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      sandbox = true;

      max-jobs = 8;
      cores = 0;

      extra-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cache.ngi0.nixos.org"
      ];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      ];
    };

    gc = {
      # automatic = true;
      dates = "weekly";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    buildMachines = [ ];
    distributedBuilds = true;
    # optional, useful when the builder has a faster internet connection than yours
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    #allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "" ];
  };
}
