{ config, pkgs, ... }: {
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
          nvim-lspconfig
          nvim-treesitter.withAllGrammars
      ];
    };
    firefox.enable = true;
    mpv.enable = true;
    zathura.enable = true;
    btop.enable = true;
    man.enable = true;
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        share = true;
      };
      dotDir = ".config/zsh";

      initExtra = ''
        [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
        eval "$(direnv hook zsh)"
      '';

      zplug = {
        enable = true;
        plugins = [{
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" ];
        }];
      };
      shellAliases = {
        gcl = "gh repo clone";
        gl = "gh repo list";
        la = "ls -A";
        ls = "ls --color=auto";
        nix-build = "sudo nixos-rebuild build --flake ~/src/nix-config/.#system-config";
        nix-switch = "sudo nixos-rebuild switch --flake ~/src/nix-config/.#system-config";
        cd = "z";
      };
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        dialect = "uk";
        style = "compact";
        keymap_mode = "vim-insert";
        enter_accept = true;
        filter_mode_shell_up_key_binding = "session";
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      attributes = [ "*.pdf diff=pdf" ];
      aliases = { };
      delta.enable = true;
      ignores = [
        ".env"
        ".direnv"
        "."
        ".envrc"
        "*.code-workspace"
      ];
      userName = "m-pluta"; # TODO
      userEmail = "michalpl2003@gmail.com"; # TODO
      extraConfig = {
        color = { ui = "auto"; };
        merge = { tool = "splice"; };
        push = { default = "simple"; };
        pull = { rebase = true; };
        branch = { autosetupmerge = true; };
        rerere = { enabled = true; };
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    kitty = {
      enable = true;
      theme = "Dark Pastel";
      settings = {
        shell = "zsh";
        editor = "nvim";
        enable_audio_bell = "no";
        background_opacity = "0.8";
        dynamic_background_opacity = "yes";
      };
      environment = {
        "EDITOR" = "nvim";
        "VISUAL" = "nvim";
      };
      shellIntegration.enableZshIntegration = true;
    };
  };

  home = {
    username = "miikey";
    homeDirectory = "/home/miikey";
    packages = with pkgs; [
      discord
      vimv
      fzf
      lf
      typst
      vscode
      python3
      kate
      gh
      spotify
      whatsapp-for-linux
    ];
    stateVersion = "23.11";
  };
}
