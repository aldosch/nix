{ pkgs, ... }:

  ###################################################################################
  #
  #  macOS's System configuration
  #
  #  All the configuration options are documented here:
  #    https://daiderd.com/nix-darwin/manual/index.html#sec-options
  #
  ###################################################################################
{
  system = {
    stateVersion = 6;

    defaults = {
      menuExtraClock.Show24Hour = true;  # show 24 hour clock

      # other macOS's defaults configuration.
      # ......
    };
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  programs.zsh.enable = true;
}
