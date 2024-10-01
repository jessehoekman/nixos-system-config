{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.loader.grub = {
    enable = true;
    device = "/dev/sdb";
    useOSProber = false;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # Allow SSH
    };
  };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };

  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin = {
          enable = true;
          user = "jesse";
        };
      };
      desktopManager.gnome.enable = true;
      xkb = {
        variant = "";
        layout = "us";
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };


  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users = {
    jesse = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel""networkmanager"];
      initialPassword = "password";
    };
  };

  environment.systemPackages = with pkgs; [
    vscode
    git
    zsh
    kitty
  ];

  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.zsh.enable = true;

  environment.variables.TERMINAL = "kitty";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
