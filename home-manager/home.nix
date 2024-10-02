{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
      firefox
      vscode
      git
      steam

      # Python Dev
      pyenv
      poetry

      # Terminal & Shell Tools
      zsh
      oh-my-zsh
      zoxide
      fzf
      ripgrep
      eza
      bat

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
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "python" "docker" "aws" ];
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
    };
    initExtra = ''
      eval "$(zoxide init zsh)"
    '';
  };

  # Kitty
  programs.kitty = {
    enable = true;
    themeFile = "Espresso";
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

  # GTK Theme
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Latte-Standard-Blue-Light";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "normal" ];
        variant = "latte";
      };
    };
    iconTheme = {
      name = "Papirus-Light";
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
    # Updated platformTheme syntax
    platformTheme = {
      name = "gtk";
    };
    style = {
      name = "kvantum";
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
