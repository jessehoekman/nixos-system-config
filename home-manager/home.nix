{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "jesse";
    homeDirectory = "/home/jesse";

    packages = with pkgs; [
      vscode
      git
      steam

      # Nix tools
      nil

      # Python Dev
      pyenv
      poetry

      # Terminal & Shell Tools
      zsh
      zoxide
      fzf
      ripgrep
      eza
      bat
      neofetch
      nix-zsh-completions
      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-history-substring-search
      tmux
      thefuck
      oh-my-posh

      # Containerization
      docker
      docker-compose

      # Networking
      curl
      wget
      nmap

      # System Monitoring
      htop
      iotop

      # Appearance
      lxappearance
      qt5ct
      gnome-tweaks

      # Contact
      telegram-desktop

      # Theming
      catppuccin-gtk
      catppuccin-kvantum
      papirus-icon-theme

    ];
  };

  programs.home-manager.enable = true;

  # Git
  programs.git = {
    enable = true;
    userName = "Jesse Hoekman";
    userEmail = "jessehoekman@hotmail.com";
  };

  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "python"
        "docker"
        "aws"
        "fzf"
        "extract"
        "sudo"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      ll = "exa -l";
      la = "exa -la";
      cat = "bat";
      gs = "git status";
      gp = "git push";
      hs = "home-manager --flake .#jesse@nixos switch";
      ns = "sudo nixos-rebuild switch --flake .#nixos";
      nc = "cd ~/Documents/nix-config";
      s = "source ~/.zshrc";
      c = "clear";
      update = "sudo nixos-rebuild switch --flake .#nixos && home-manager switch --flake .#jesse@nixos";
      tf = "fuck --yeah";
    };
    initExtra = ''
      eval "$(zoxide init zsh)"

      # Load syntax highlighting and autosuggestions
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

      # Ctrl+Space to accept the current suggestion
      bindkey '^ ' autosuggest-accept


      # Avoid duplicates in history
      setopt HIST_IGNORE_ALL_DUPS

      # Automatically cd into typed directory
      setopt autocd

      # Initialize fastfetch
      fastfetch

      # Automatically cd into typed directory
      setopt autocd

      eval $(thefuck --alias)
      export THEFUCK_REQUIRE_CONFIRMATION=false
      export THEFUCK_ALTER_HISTORY=true

      # Initialize Oh My Posh
      eval "$(oh-my-posh init zsh --config ${config.xdg.configHome}/oh-my-posh/catppuccin_mocha.omp.json)"

      # Initialize neofetch with custom config
      neofetch --config ~/.config/neofetch/config.conf
    '';
  };

  xdg.configFile."oh-my-posh/catppuccin_mocha.omp.json".source = /home/jesse/Documents/nix-config/home-manager/catppuccin.omp.json;
  xdg.configFile."neofetch/config.conf".source = /home/jesse/Documents/nix-config/neofetch/config.conf;

  # Kitty
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "1";
      enable_audio_bell = false;
      window_padding_width = 8;
      tab_bar_style = "powerline";
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      scrollback_lines = 10000;
      confirm_os_window_close = 0;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # GTK Theme
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "normal" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
  };

  # Qt Theme
  qt = {
    enable = true;
    platformTheme = {
      name = "gtk";
    };
    style = {
      name = "kvantum";
      package = pkgs.catppuccin-kvantum;
    };
  };

  # Cursor Theme
  home.pointerCursor = {
    name = "Catppuccin-Latte-Light-Cursors";
    package = pkgs.catppuccin-cursors.latteLight;
    size = 16;
  };

  programs.bash.enable = true;
  targets.genericLinux.enable = true;

  # Direnv configuration
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
