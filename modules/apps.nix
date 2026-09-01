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
    (tmux.overrideAttrs (old: {
      configureFlags = (old.configureFlags or []) ++ [ "--disable-jemalloc" ];
    }))
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
      "font-agave"
      "font-geist"
      "font-geist-mono"
      "font-recursive-mono-nerd-font"
      "ghostty"
      "imageoptim"
      "itsycal"
      "karabiner-elements"
      # opencode-desktop removed: redundant with the opencode CLI
      # (anomalyco/tap/opencode) and it was 427MB of unused GUI.
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
      "rauchg/typing-stats/typing-stats"
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
      # html2markdown: HTML → GFM markdown CLI, used by the strip-markup fish
      # function (clipboard/file/stdin/arg in, stdout + pbcopy out).
      "html2markdown"
      "httrack"
      "imagemagick"
      "kew"
      # pkgconf: build dep for the locally-patched kew build (~/repos/kew,
      # installed to ~/.local/bin via kew-sync). See docs/content/docs/packages.mdx.
      "pkgconf"
      # node removed: fnm (nix) is the single source of Node. The brew formula
      # was shadowed by fnm in PATH anyway, so nothing used it directly.
      # (sf, which depended on it, was removed at the same time.)
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
      "fx-agent"
      "oven-sh/bun/bun"
      # sf removed: depended on the brew node formula (also removed); fnm
      # provides node and sf is unused.
    ];

    # Determine brews based on hostname
    hostBrews = if hostname == "book" then bookOnlyBrews else minOnlyBrews;
  in {
    enable = true;

    taps = [
      "anomalyco/tap"
      "oven-sh/bun"
      "raskrebs/sonar"
      "vjeantet/tap"
      {
        name = "rauchg/typing-stats";
        clone_target = "https://github.com/rauchg/typing-stats";
        trusted = true;
      }
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
