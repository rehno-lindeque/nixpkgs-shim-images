flake: {
  config,
  lib,
  ...
}: let
  cfg = config.images.sdImage;
in {
  options = {
    images.sdImage.enable = lib.mkEnableOption ''
      Whether to generate an SD image file.
    '';
  };

  imports = [
    # Conditionally import the image module
    (args @ {pkgs, ...}: let
      module = builtins.removeAttrs (import "${flake.inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix" args) ["imports"];
      config = lib.mkIf cfg.enable module.config;
    in
      module // {inherit config;})
  ];
}
