{ config, pkgs, lib, ... }:

{
  home = {
    stateVersion = "24.05";
    username = "mikey";
    homeDirectory = "/home/mikey";

    packages = with pkgs; [
      discord
      google-chrome
      neofetch
      spotify
      audacity
      flameshot
      gimp
      vlc
      mpv
      popcorntime
      mullvad-vpn
      obs-studio
      shotcut
      # qbittorrent
      transmission
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    zoxide.enable = true;
    starship.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    alacritty.enable = true;
    kitty = {
      enable = true;
      theme = "Dark Pastel";
      settings = {
        shell = "bash";
        editor = "vim";
        background_opacity = "1";
        dynamic_background_opacity = "yes";
      };
      environment = {
        "EDITOR" = "vim";
        "VISUAL" = "vim";
      };
    };

    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_macchiato";
        editor = {
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          indent-guides = {
            character = "|";
            render = true;
          };
          bufferline = "always";
          scrolloff = 5;
          line-number = "relative";
          rulers = [ 80 120 ];
        };
        keys = {
          normal = {
            space = {
              "w" = ":write";
              "q" = ":quit";
            };
            "V" = "extend_line_below";
          };
          select = {
            "V" = "extend_line_below";
          };
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
        }
      ];
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
