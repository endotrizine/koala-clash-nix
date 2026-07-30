{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.koala-clash;
in
{
  options.programs.koala-clash = {
    enable = lib.mkEnableOption "Koala Clash";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.koala-clash
    ];

    security.wrappers.koala-clash = {
      owner = "root";
      group = "root";
      source = "${pkgs.koala-clash}/bin/koala-clash";
      capabilities = "cap_net_admin+ep";
    };
  };
}
