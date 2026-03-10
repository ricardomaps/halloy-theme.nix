# halloy-theme.nix

This repo has the [community themes for Halloy](https://themes.halloy.chat/?/toToml) packaged for nix, for declarative use in the Home Manager module of Halloy, for instance.

## Usage
Add this flake to your flake's inputs:

```nix
  inputs = {
    halloy-theme = {
      url = "github:ricardomaps/halloy-theme.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }
```

Optionally, you can use the overlay provided by this flake:

```nix
  nixpkgs.overlays = [
    inputs.halloy-theme.overlays.default
  ];
```

If you are using the Home Manager module for Halloy you can do something like this:

```nix
  programs.halloy = {
    enable = true;
    themes = with inputs.halloy-theme.packages.x86_64-linux; {
      inherit Nord;
      inherit "Catppuccin Latte";
    };
    settings = {
      theme = "Nord";
    };
  };
```
