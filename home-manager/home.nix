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
    };
    initExtra = ''
      eval "$(zoxide init zsh)"
    '';
  };

  # Kitty
  programs.kitty = {
    enable = true;
    theme = "Solarized Dark";  # You can choose a different theme
    font = {
      name = "JetBrains Mono";
      size = 12;
    };
    settings = {
      background_opacity = "0.95";
      enable_audio_bell = false;
    };
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
