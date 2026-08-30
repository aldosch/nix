# macOS's System configuration 🖥️
# https://nix-darwin.github.io/nix-darwin/manual/index.html
{ pkgs, hostname, ... }:
let
  # Host-specific system preferences
  hostPrefs = {
    min = {
      hideMenuBar = false;
      # Add more min-specific preferences here
    };
    book = {
      hideMenuBar = false;
      # Add more book-specific preferences here
    };
  };

  # Get preferences for current host
  prefs = hostPrefs.${hostname};
in
{
  system = {
    stateVersion = 6;
    startup.chime = false;
    defaults = {
      CustomUserPreferences = {
        "com.apple.TextEdit" = {
          RichText = false;
          SmartQuotes = false;
        };
      };
      dock = {
        appswitcher-all-displays = true;                    # 🔄 Show app switcher (Cmd-Tab) on all displays.
        autohide = true;                                    # 🙈 Auto-hide Dock to save screen space. Default is false.
        mineffect = "scale";                                # 🧞 Minimize window effect: "genie" or "scale".
        minimize-to-application = false;                     # 📥 Minimize windows into app icon instead of separate slot.
        orientation = "left";                               # ↔️ Dock position: "bottom" (default), "left", or "right".
        scroll-to-open = true;                              # 🖱️ Scroll over Dock app to cycle through its windows.
        show-recents = false;                               # 🕓 Show recent applications section (disabled; conflicts with static-only).
        static-only = true;                                 # 📌 Hide running-indicator-only apps; show pinned items only.
        tilesize = 48;                                      # 🟦 Icon size in Dock (pixels).
        wvous-bl-corner = 1;                                # ↙️ Hot corner action for bottom left corner
        wvous-br-corner = 1;                                # ↘️ Hot corner action for bottom right corner
        wvous-tl-corner = 1;                                # ↖️ Hot corner action for top left corner
        wvous-tr-corner = 1;                                # ↗️ Hot corner action for top left corner
        # persistent-apps = [                               # 📑 Persistent applications, spacers, files, and folders in the dock.
        #   { app = "/Applications/Launchpad.app"; }        # 🚧 TODO FIX: https://github.com/nix-darwin/nix-darwin/issues/1250
        # ];
      };
      finder = {
        _FXSortFoldersFirst = true;                         # 📂 Sort folders first when sorting by name.
        AppleShowAllExtensions = true;                      # 🏷️ Always show filename extensions.
        AppleShowAllFiles = true;                           # 👀 Show hidden files (e.g., dotfiles).
        FXEnableExtensionChangeWarning = false;             # 🚫 Disable warning when changing file extensions.
        FXRemoveOldTrashItems = true;                       # 🗑️ Auto-empty trash items older than 30 days.
        NewWindowTarget = "Other";                          # 📁 New Finder windows target custom path (see below).
        NewWindowTargetPath = "~/";                         # 🏡 Path used when NewWindowTarget = "Other".
        ShowPathbar = true;                                 # 🛤️ Show path bar at bottom of Finder windows.
        ShowStatusBar = true;                               # ℹ️ Show status bar (item counts, free space).
      };
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 3.0;                    # 🖱️ Mouse tracking speed (higher is faster). May require logout/reboot.
      };
      hitoolbox = {
        AppleFnUsageType = "Do Nothing";                    # 🔘 Set Fn key behavior: e.g., do nothing vs action.
      };
      loginwindow = {
        DisableConsoleAccess = true;                        # 🔒 Disable console login (Cmd+Opt+Fn+F2) for extra security.
        GuestEnabled = false;                               # 🚷 Disable Guest user at login screen.
      };
      NSGlobalDomain = {
        _HIHideMenuBar = prefs.hideMenuBar;                 # 🫥 Auto hide menu bar
        "com.apple.sound.beep.feedback" = 0;                # 🔇 Disable beep feedback on volume change.
        "com.apple.sound.beep.volume" = 0.0;                # 🤫 Set alert/"beep" volume to silent.
        "com.apple.trackpad.forceClick" = false;            # ⛔️ Disable Force Click (haptic deeper click).
        "com.apple.trackpad.scaling" = 3.0;                 # 🏃‍♂️ Trackpad tracking speed (higher is faster).
        AppleEnableMouseSwipeNavigateWithScrolls = false;   # 🚫 Disable two-finger swipe navigation in apps.
        AppleInterfaceStyle = "Dark";                       # 🌛 Dark appearance (used when Auto mode switches to dark).
        AppleInterfaceStyleSwitchesAutomatically = true;    # 🌓 Allow Auto appearance switching (light/dark by system).
        AppleMetricUnits = 1;                               # 📏 Use metric units.
        AppleShowScrollBars = "WhenScrolling";              # 🖱️ Show scroll bars only while scrolling: "Automatic", "WhenScrolling", "Always".
        AppleKeyboardUIMode = 3;
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;            # 🔄 Enable automatic macOS updates.
      };
      trackpad = {
        Clicking = true;                                    # 👆 Tap-to-click for trackpad (may not reflect in UI immediately).
        # Dragging = true;                                    # ✋ Enable dragging; interacts with drag styles in Accessibility.
        # TrackpadThreeFingerDrag = true;                     # 🤟 Enable three-finger drag (Accessibility option).
      };
      WindowManager = {
        AutoHide = true;                                    # 🛰️ Auto-hide Stage Manager’s recent apps strip.
        EnableStandardClickToShowDesktop = false;           # 🚫 Disable “click wallpaper to reveal desktop”.
        StandardHideDesktopIcons = true;                    # 🧳 Hide desktop items (standard desktop mode).
        StandardHideWidgets = true;                         # 🪟 Hide desktop widgets (standard desktop mode).
      };
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;      # 🟢 Allow sudo with Touch ID for local PAM config.
  programs.zsh.enable = true;                               # 💻 Ensure zsh profile is managed by nix-darwin.
  programs.fish.enable = true;

  system.activationScripts.postActivation.text = ''
    # Link pnpm global config from dotfiles so onlyBuiltDependencies is always set.
    mkdir -p "$HOME/Library/Preferences/pnpm"
    ln -sf "$HOME/.config/pnpm/rc" "$HOME/Library/Preferences/pnpm/rc"

    # ── Spotlight privacy exclusions ──────────────────────────────────
    # Stop Spotlight from indexing pure-cache and store paths (45+ GB that
    # never contain anything searchable). Without this, mds/mds_stores burn
    # CPU re-indexing node_modules trees and caches continuously. The list is
    # the same one System Settings > Spotlight > Search Privacy writes, so it
    # stays visible/editable in the UI. Rewritten idempotently on every apply;
    # mds is restarted so the change takes effect immediately.
    spotlight_plist="/System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist"
    if [ ! -f "$spotlight_plist" ]; then
      spotlight_plist="/.Spotlight-V100/VolumeConfiguration.plist"
    fi
    if [ -f "$spotlight_plist" ]; then
      plutil -remove ExcludedPaths "$spotlight_plist" 2>/dev/null || true
      plutil -insert ExcludedPaths -xml '<array>
        <string>/Users/aldo/Library/Caches</string>
        <string>/Users/aldo/.cache</string>
        <string>/Users/aldo/.npm</string>
        <string>/nix/store</string>
        <string>/nix/var</string>
      </array>' "$spotlight_plist" 2>/dev/null || true
      launchctl kickstart -k system/com.apple.metadata.mds 2>/dev/null || killall mds 2>/dev/null || true
    fi

    # ── Disable unwanted background LaunchAgents ──────────────────────
    # Grammarly Desktop (user explicitly does not want it popping up) and
    # Google's Keystone/Updater agents (redundant: brew manages Chrome Canary
    # updates during nixx). `launchctl disable` persists in the launchd
    # overrides DB, so the agents stay off even when an app update restores
    # its plists. bootout kills any currently loaded instance.
    # The apps themselves stay installed and launchable.
    aldo_uid=$(id -u aldo)
    for label in \
      com.grammarly.ProjectLlama.Shepherd \
      com.grammarly.ProjectLlama.Uninstaller \
      com.grammarly.ProjectLlama.UpdateService \
      com.google.GoogleUpdater.wake \
      com.google.keystone.agent \
      com.google.keystone.xpcservice; do
      launchctl bootout "user/$aldo_uid/$label" 2>/dev/null || true
      launchctl disable "user/$aldo_uid/$label" 2>/dev/null || true
    done
    # Keystone also registers a copy in the system domain.
    launchctl bootout "system/com.google.keystone.xpcservice" 2>/dev/null || true
    launchctl disable "system/com.google.keystone.xpcservice" 2>/dev/null || true
  '';
}
