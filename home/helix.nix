{ pkgs, lib, config, ... }:

{
  programs.helix = {
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
}
