{ config, pkgs, ... }:

{
  home = {
    stateVersion = "24.05";
    username = "mikey";
    homeDirectory = "/home/mikey";

    packages = with pkgs; [
      discord
      neofetch
      obsidian
      zotero
      spotify
      obs-studio
      vlc
      
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    btop.enable = true;
    home-manager.enable = true;
    zoxide.enable = true;
    starship.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    kitty = {
      enable = true;
      theme = "Dark Pastel";
      settings = {
        shell = "bash";
        editor = "nvim";
        background_opacity = "1";
        dynamic_background_opacity = "yes";
      };
      environment = {
        "EDITOR" = "lvim";
        "VISUAL" = "lvim";
      };
    };

    vscode = {
	    enable = true;
	    package = pkgs.vscode.fhs;
    };

    git = {
      enable = true;
      delta.enable = true;
      attributes = [ "*.pdf diff=pdf" ];
      ignores = [
        ".env"
        ".direnv"
        ".obsidian"
        "."
        ".envrc"
        "zig-cache"
        "zig-out"
        "*.code-workspace"
      ];
      userName = "Michal Pluta";
      userEmail = "michalpl2003@gmail.com";
      extraConfig = {
        color.ui = "auto";
        merge.tool = "splice";
        push.default = "simple";
        pull.rebase = true;
      };
    };
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
    };
    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
    };
  };
}
