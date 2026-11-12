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
    fswatch
    fzf
    gh
    git
    go
    gum
    htop
    # ice-bar removed: Ice doesn't run on macOS 27 beta, and macOS 27 hides
    # menu bar icons natively, so no menu bar manager is needed.
    iina
    ipinfo
    jq
    ncdu
    neovim
    # ninja + python312: build deps for the local ungoogled-chromium fork
    # (~/repos/ungoogled-chromium). Brew-managed copies keep getting removed
    # by the zap cleanup below, so they live here instead.
    ninja
    python312
    ollama
    openssl
    pika
    rclone
    restic
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
      "alfred"
      "aqua-voice"
      "cleanshot"
      "codex"
      "ente-auth"
      "font-agave"
      "font-geist"
      "font-geist-mono"
      "font-recursive-mono-nerd-font"
      # ghostty removed: built from ~/repos/ghostty (branch aldo/patches, hides
      # the tab bar UI). ghostty-sync merges upstream tags + rebuilds; zap would
      # otherwise uninstall the locally-built app.
      "imageoptim"
      "itsycal"
      "karabiner-elements"
      # opencode-desktop removed: redundant with the opencode CLI
      # and it was 427MB of unused GUI.
      "raycast"
      "rectangle"
      "signal"
      "typora"
      "ungoogled-chromium"
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
      "ben0128/nibble/nibble"
      "docker-desktop"
      "font-sf-mono-nerd-font-ligaturized"
      "font-sf-pro"
      "google-chrome@canary"
      # herdr: agent-runner app (herdr.dev). auto_updates cask, so the app
      # self-updates and brew's non-greedy upgrade skips it. Config lives in
      # ~/.config/herdr-app/ (tracked, app-written files gitignored).
      "herdr-app"
      "microsoft-teams"
      "notion"
      # openchamber: GUI workspace around opencode (openchamber.dev). Requires
      # the opencode 2.x server API, so it runs its bundled 2.x opencode; the
      # patched 1.x build can't serve it. Reads the shared ~/.config/opencode.
      # auto_updates cask, so the app self-updates. App state in
      # ~/.config/openchamber/ (gitignored). See docs/content/docs/agent.mdx.
      "openchamber"
      "slack"
      # "zoom"
    ];

    # Determine casks based on hostname
    hostCasks = if hostname == "book" then bookOnlyCasks else minOnlyCasks;

    # Shared CLI tools for both machines
    commonBrews = [
      # opencode not declared: the patched local build (~/.local/bin) is
      # primary; `brew install anomalyco/tap/opencode` on demand if a
      # fallback is ever needed (fish wrappers already fall back if present)
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
      # whisper.cpp: canonical brew formula name (the `whisper-cpp` token is an
      # alias; drift checks compare installed names, so declare the canonical one)
      "whisper.cpp"
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
      # tfenv: terraform version manager. State (installed terraform versions
      # + version pin) lives in ~/.config/tfenv (gitignored).
      "tfenv"
      # sf removed: depended on the brew node formula (also removed); fnm
      # provides node and sf is unused.
      # displaylink removed: no longer a homebrew formula (brew bundle fails on it)
    ];

    # Determine brews based on hostname
    hostBrews = if hostname == "book" then bookOnlyBrews else minOnlyBrews;
  in {
    enable = true;

    taps = [
      "oven-sh/bun"
      "raskrebs/sonar"
      "vjeantet/tap"
      {
        name = "rauchg/typing-stats";
        clone_target = "https://github.com/rauchg/typing-stats";
        trusted = true;
      }
      # nibble: ad-hoc signed cask, requires trust. See bookOnlyCasks.
      {
        name = "ben0128/nibble";
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
