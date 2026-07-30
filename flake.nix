{
  description = "Koala Clash for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      overlays.default = final: prev: {
        koala-clash = final.callPackage ./pkgs/koala-clash { };
      };

      nixosModules.default = import ./nixosModules/default.nix;

    }
    // flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            self.overlays.default
          ];
        };
      in
      {
        packages.default = pkgs.koala-clash;
      }
    );
}
