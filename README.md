# ❄️ nix

aldo's personal macos nix config.

![example screenshot](/screenshot.png)

## installation

download and install nix

```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

download and install brew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

create config dir

```bash
mkdir ~/.config
```

clone repo

```bash
cd ~/.config
git clone git@github.com:aldosch/nix.git
```

may require xcode command line tools to be installed via popup dialogue.
could be simpler to download as .zip file.

## commands

- repo should be cloned to `~/.config/nix`
- commands should be run from here too.
- replace `min` with actual hostname

### build

```bash
nix build .#darwinConfigurations.min.system --extra-experimental-features 'nix-command flakes'
```

### apply

```bash
sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#min
```

### cleanup

```bash
nix-collect-garbage -d
```

### set fish shell

```bash
grep /run/current-system/sw/bin/fish /etc/shells || echo /run/current-system/sw/bin/fish | sudo tee -a /etc/shells
chsh -s /run/current-system/sw/bin/fish
```

#### disable cli greeting

```bash
touch ~/.hushlogin
```

### set node version

```bash
fnm use 24
fnm default 24
```

## ui based changes

- finder
  - edit finder toolbar
  - `cmd+j` "Calculate all sizes"
  - show all filenames
  - search current folder by default
  - new windows open `~`
  - edit sidebar
    - hide tags
- 1password
  - set hotkey
  - search `ssh` and then setup cli developer tooling to manage ssh keys
- disable spotlight keyboard shortcuts
- alfred
  - register license
  - set preferences folder to `~/.config/alfred` to import
  - set hotkey
- chromium
  - search engine
  - default page zoom
  - default font
  - hide bookmarks bar
  - install custom new tab page extension (from `chromium/chrome-blank-new-tab/` via Developer Mode)
  - install [chromium-web-store](https://github.com/NeverDecaf/chromium-web-store)
    - update URL: `https://raw.githubusercontent.com/NeverDecaf/chromium-web-store/master/updates.xml`
    - set `chrome://flags/#extension-mime-request-handling` to `Always prompt for install`
  - extensions (install via Chromium Web Store):

    | Extension | ID | Notes |
    |---|---|---|
    | Kagi Search | `cdglnehniifkbagbbombnjghhcihifij` | enable in incognito |
    | uBlock Origin | `cjpalhdlnbpafiamejdnhcphjbkeiagm` | see config below |
    | Dark Reader | `eimadpbcbfnmbkopoojfekhnkhdbieeh` | see config below |
    | Tab Pinner (Keyboard Shortcuts) | `mbcjcnomlakhkechnbhmfjhnnllpbmlh` | |
    | Chromium Web Store | `ocaahdebbfolfmndjeplogmgcagdmblk` | installed first, see above |
    | 1Password – Password Manager | `aeblfdkhhhdcdjpifhhbdiojplfjncoa` | keep disabled |
    | React Developer Tools | `fmkadmapgofadopljbjfkapdkoienihi` | keep disabled |

  - **uBlock Origin config**: enable the following filter lists (off by default):
    - Annoyances > EasyList Cookie
    - Annoyances > uBlock filters – Social widgets (or equivalent social widget list)

  - **Dark Reader config**: Settings > Site List > select **"Inverted list only"**
    - This means dark mode is opt-in per site (toggle it for a specific site rather than applying globally)
    - Dark Reader respects the macOS system theme — dark mode only activates when the system switches to dark (auto-scheduled by timezone/sunset)
- manage default browsers with velja
- cleanshot
  - register license
  - disable default shortcuts
  - set export location to `~/shots`
  - set after capture steps
  - window screenshots transparent
  - hide/show overlays shortcut to `cmd+shift+6`
  - advanced
    - remove 2x retina suffix
    - file name: rm Cleanshot and set to UTC
- ice set hidden apps
  - hide icon
  - hide all
- slack: Accessibility > Keyboard > press up arrow to edit last message

## TODO:

- [ ] trackpad 3 finger swipe between fullscreen windows
  - don't need 3 finger drag on windows
- [ ] disable macbook charging sound
  - `defaults write com.apple.PowerChime ChimeOnAllHardware -bool false; killall PowerChime`
- [ ] set slack theme to system
- [ ] prevent display sleep / screen saver when powered
- [ ] remove spotlight menu bar icon
- [ ] add itsycal
- [ ] `export PATH="/Users/aldo/.bun/bin:$PATH"`
- [ ] wallpaper
- [ ] ice bar preferences
- [ ] fuzzy find active window
- [ ] terminal font size (or ghostty)
</content>
</invoke>
