# nix
aldo's personal macos nix config.

## commands
- repo should be cloned to `~/.config/nix`
- commands should be run from here too.
- replace `min` with actual hostname

### build
```bash
nix build .#darwinConfigurations.min.system --extra-experimental-features 'nix-command flakes'
```


## apply
```bash
sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#min
```