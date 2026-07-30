<div align="center">

🇬🇧 English | [🇷🇺 Русский](README.ru.md)

</div>

# Koala Clash NixOS Flake

Unofficial NixOS flake for [Koala Clash](https://github.com/koala-clash/koala-clash).

This flake provides:

- Koala Clash package for NixOS
- NixOS module integration
- TUN mode support without running the application as root

## Requirements

- NixOS
- flakes enabled
- `x86_64-linux`

## Usage

### Add the flake input

Add Koala Clash to the `inputs` section of your NixOS flake:

```nix
inputs = {
  # other inputs...

  koala-clash.url = "github:endotrizine/koala-clash-nix";
};
````

---

### Import the NixOS module

Add the Koala Clash module to your `nixosSystem` modules list:

```nix
modules = [
  # other modules...

  inputs.koala-clash.nixosModules.default
];
```

Example:

```nix
nixosConfigurations = {
  hostname = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      ./configuration.nix

      inputs.koala-clash.nixosModules.default
    ];
  };
};
```

---

### Enable Koala Clash

Add the following option to your NixOS configuration:

```nix
{
  programs.koala-clash.enable = true;
}
```

Example:

```nix
{ config, pkgs, ... }:

{
  programs.koala-clash.enable = true;

  # other NixOS options...
}
```

---

### Rebuild your system

Apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

Replace `hostname` with the name of your NixOS configuration.

After rebuilding, Koala Clash can be launched with:

```bash
koala-clash
```

---

## TUN mode

Koala Clash requires access to create a TUN interface.

Normally this requires elevated privileges:

```bash
sudo koala-clash
```

This flake configures the required Linux capability automatically through a NixOS wrapper.

The module provides:

```
CAP_NET_ADMIN
```

allowing Koala Clash to create TUN interfaces while running as a normal user.

You can verify that the capability is applied:

```bash
getcap /run/wrappers/bin/koala-clash
```

Expected output:

```text
/run/wrappers/bin/koala-clash cap_net_admin=ep
```

---

## Updating

Update the flake input:

```bash
nix flake lock --update-input koala-clash
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

---

## Package usage without the NixOS module

The package can also be used directly:

```nix
environment.systemPackages = [
  inputs.koala-clash.packages.x86_64-linux.default
];
```

Note that using only the package does not configure permissions required for TUN mode.

For full functionality, use the NixOS module.

---

## Troubleshooting

### TUN permission error

If Koala Clash logs say:

```text
Start TUN listening error: configure tun interface: operation not permitted
```

make sure the NixOS module is enabled:

```nix
programs.koala-clash.enable = true;
```

and rebuild your system:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

---

## Credits

Koala Clash is developed by its original authors.

This repository only provides NixOS packaging and integration.
