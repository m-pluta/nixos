{ config, pkgs, lib, ... }:

let
  helixConfig = import ./helix.nix { inherit pkgs lib config; };
in
{
  home = {
    stateVersion = "25.05";
    username = "mikey";
    homeDirectory = "/home/mikey";

    packages = with pkgs; [
      # keep-sorted start sticky_comments=no
      atool
      audacity
      discord
      flameshot
      gimp
      google-chrome
      mpv
      mullvad-vpn
      neofetch
      neovim
      obs-studio
      popcorntime
      qbittorrent
      shotcut
      spotify
      vlc
      zotero
      # keep-sorted end
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = false;
        update_check = false;
        dialect = "uk";
        invert = true;
        smart_sort = true;
        style = "compact";
        keymap_mode = "vim-insert";
        enter_accept = true;
        filter_mode_shell_up_key_binding = "session";
        workspaces = true;
        daemon.enabled = true;
      };
    };

    alacritty.enable = true;
    kitty = {
      enable = true;
      theme = "Dark Pastel";
      settings = {
        shell = "bash";
        editor = "hx";
        background_opacity = "1";
        dynamic_background_opacity = "yes";
      };
      environment = {
        "EDITOR" = "hx";
        "VISUAL" = "hx";
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  } // helixConfig.programs;

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

  systemd.user = {
    enable = true;
    services = {
      atuin-daemon = {
        Unit.Description = "Run the atuin daemon.";
        Install.WantedBy = [ "default.target" ];
        Service.ExecStart = "${pkgs.atuin}/bin/atuin daemon";
      };
    };
  };
}
