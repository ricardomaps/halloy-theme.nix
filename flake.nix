{
  description = "Halloy Community Themes packaged for nix consumption";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      flake = {
        overlays.halloy-theme = final: prev: {
          halloy-theme = self.packages.${prev.stdenv.hostPlatform.system};
        };
        overlays.default = self.overlays.halloy-theme;
      };
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { lib, pkgs, ... }:
        let
          withoutTOMLExtension = file: lib.removeSuffix ".toml" file;
          themeFiles =
            lib.attrNames (builtins.readDir ./themes);
          mkThemePackage = themeFile:
            let name = withoutTOMLExtension themeFile;
            in lib.nameValuePair name
            (pkgs.runCommand name {} ''
              cp ${./themes}/${themeFile} $out
            '');
          themeDerivations = map mkThemePackage themeFiles;
        in { packages = lib.listToAttrs themeDerivations; };
    };
}
