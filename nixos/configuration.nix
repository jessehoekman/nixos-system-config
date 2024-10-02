{ inputs, lib, config, pkgs, ... }:

{
  # Import other configuration files
  imports = [
    ./hardware-configuration.nix
    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
  ];

  # Nixpkgs configuration
  nixpkgs.config.allowUnfree = true;

  # Nix configuration
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
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Boot configuration
  boot.loader.grub = {
    enable = true;
    device = "/dev/sdb";
    useOSProber = false;
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # Allow SSH
    };
  };

  # Time and localization
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

  # Consolidated services configuration
  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
      };
      desktopManager.gnome.enable = true;
      xkb = {
        variant = "";
        layout = "us";
      };
    };

    # Move autoLogin configuration here
    displayManager.autoLogin = {
      enable = true;
      user = "jesse";
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    blueman.enable = true;
  };

  # Add this to clean up old channel directories
  system.activationScripts.cleanupNixChannels = ''
    echo "Cleaning up Nix channels..."
    rm -rf /root/.nix-defexpr/channels
    rm -rf /nix/var/nix/profiles/per-user/root/channels
    rm -rf /home/jesse/.nix-defexpr/channels
  '';

  # Disable getty services
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Security
  security.rtkit.enable = true;

  # User configuration
  users.users.jesse = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "password";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vscode
    git
    zsh
    kitty
    bluez
    pavucontrol
    bluez-tools
  ];

  # Bluetooth configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true; # For battery reporting
      };
    };
  };

  # Additional program configurations
  programs = {
    gnome-terminal.enable = false;
    firefox.enable = true;
    steam.enable = true;
    zsh.enable = true;
  };

  # Environment variables
  environment.variables.TERMINAL = "kitty";

  # System state version
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
