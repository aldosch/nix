{ pkgs, lib, hostname, ...}: {
  nixpkgs.config.allowUnfree = true;

  # Git global configuration
  environment.etc."gitconfig".text = ''
    [user]
      name = aldosch
      email = git@aldo.io
    [push]
      default = current
  '';

  # nix packages
  environment.systemPackages = with pkgs; [
    # `e` wrapper: mirrors the fish/functions/e.fish shortcut so `sudo e` works
    (pkgs.writeShellScriptBin "e" ''
      if [ $# -eq 0 ]; then
        exec nvim .
      else
        exec nvim "$@"
      fi
    '')
    # httrack
    _1password-cli
    bat
    curl
    dig
    direnv
    doggo
    fd
    ffmpeg
    fish
    fnm
    fzf
    gh
    git
    go
    gum
    htop
    ice-bar
    iina
    ipinfo
    isync
    jq
    ncdu
    neovim
    ollama
    openssl
    pika
    rclone
    rsync
    sad
    starship
    tlrc
    tree-sitter
    tmux
    tree
    valkey
    zig
  ];

  homebrew = let
    # Shared applications for both machines
    commonCasks = [
      "ableton-live-suite"
      "alfred"
      "anythingllm"
      "calibre"
      "cleanshot"
      "codex"
      "ente-auth"
      "font-recursive-mono-nerd-font"
      "ghostty"
      "imageoptim"
      "itsycal"
      "karabiner-elements"
      "opencode-desktop"
      "orion"
      "raycast"
      "rectangle"
      "signal"
      "soundsource"
      "spotify"
      "tailscale-app"
      "transmission"
      "typora"
      "ungoogled-chromium"
      "waterfox"
     ];

    # Mac Mini specific applications
    minOnlyCasks = [
      "1password"
      "discord"
      "lulu"
    ];

    # MacBook (work) specific applications
    bookOnlyCasks = [
      "cursor"
      "cursor-cli"
      "docker-desktop"
      "font-sf-mono-nerd-font-ligaturized"
      "font-sf-pro"
      "google-chrome@canary"
      "grammarly-desktop"
      "microsoft-teams"
      "notion"
      "slack"
      "superhuman"
      # "zoom"
    ];

    # Determine casks based on hostname
    hostCasks = if hostname == "book" then bookOnlyCasks else minOnlyCasks;

    # Shared CLI tools for both machines
    commonBrews = [
      "anomalyco/tap/opencode"
      "eza"
      "httrack"
      "imagemagick"
      "kew"
      "node"
      "poppler"
      "raskrebs/sonar/sonar"
      "ripgrep"
      "uv"
      "vjeantet/tap/alerter"
      "wget"
      "whisper-cpp"
      "yt-dlp"
    ];

    # Mac Mini specific CLI tools
    minOnlyBrews = [
    ];

    # MacBook (work) specific CLI tools
    bookOnlyBrews = [
      "awscli"
      "deno"
      "oven-sh/bun/bun"
      "sf"
    ];

    # Determine brews based on hostname
    hostBrews = if hostname == "book" then bookOnlyBrews else minOnlyBrews;
  in {
    enable = true;

    taps = [
      "anomalyco/tap"
      "oven-sh/bun"
      "vjeantet/tap"
    ];

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # 'zap': uninstalls all formulae (and related files) not listed here.
      cleanup = "zap";
    };

    # `brew install`
    brews = commonBrews ++ hostBrews;

    # `brew install --cask`
    casks = commonCasks ++ hostCasks;
  };
}
