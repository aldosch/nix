{ pkgs, lib, ...}: {

  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
		_1password-cli
    bun
    curl
    dig
    doggo
    fish
    gh
    git
    htop
    jq
    nodePackages_latest.vercel
    raycast
    rectangle
    tldr
    tree
    zed-editor
  ];

  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    # taps = [
    #  "homebrew/services"
    # ];

    # `brew install`
    brews = [];

    # `brew install --cask`
    casks = [
      "1password"
      "ungoogled-chromium"
      "karabiner-elements"
      "transmission"
    ];
  };
}
