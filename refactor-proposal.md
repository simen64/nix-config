# Refactor proposal for this Nix config

## Current layout (today)

- `flake.nix` wires three hosts and inputs.
- `hosts/<machine>/configuration.nix` contains host-specific NixOS or Darwin settings.
- `nixosModules/` holds shared NixOS feature modules (e.g., `desktop-apps.nix`, `user.nix`).
- `homeManagerModules/` holds shared HM feature modules (e.g., `terminal.nix`, `dev.nix`).
- `config/` contains app config files (e.g., `nvim`, `ghostty`, `ssh`).

## Problems this creates

- Apps and features are spread across multiple files and layers, making “add an app” a multi-hop change.
- Host files carry too much logic instead of just selecting a profile.
- There is no single catalog for apps (Nixpkgs packages + Flatpak + Homebrew).

## Target structure (proposal)

Keep the current layers, but add two concepts that make the repo feel “distro-like”:

1. **Profiles (roles)**: curated feature sets that hosts select.
   - **System profiles** (NixOS): `nixosProfiles/` or `nixosModules/profiles/`
   - **User profiles** (Home Manager): `homeProfiles/` or `homeManagerModules/profiles/`

2. **App bundles**: a single catalog layer for apps, grouped by purpose.
   - `apps/` (new) with:
     - `apps/bundles/*.nix` (e.g., `desktop.nix`, `work.nix`, `dev.nix`)
     - `apps/catalog.nix` (central registry of apps across Nixpkgs/Flatpak/Homebrew)

Host configs should only select:

- `profiles = [ "desktop" "gaming" "laptop" ];`
- `appBundles = [ "core" "dev" "work" ];`
- minimal host overrides (hardware, kernel, networking).

## Proposed file map

```
apps/
  catalog.nix         # canonical list of apps by name and source
  bundles/
    core.nix
    desktop.nix
    dev.nix
    work.nix
homeManagerModules/
  profiles/
    base.nix
    dev.nix
    laptop.nix
nixosModules/
  profiles/
    base.nix
    desktop.nix
    laptop.nix
```

## App catalog design (single source of truth)

`apps/catalog.nix` should define one place to list apps and their source:

- **Nixpkgs** packages for both NixOS and HM.
- **Flatpak** apps for NixOS desktops (via `nix-flatpak`).
- **Homebrew** casks for Darwin.

The goal: adding an app = one line in the catalog + add to a bundle.

## How “add an app” should work

1. Add app once in `apps/catalog.nix`.
2. Add it to a bundle in `apps/bundles/<bundle>.nix`.
3. Host only selects bundles; no direct app changes in `hosts/`.

## Migration steps (incremental)

1. **Introduce app catalog + bundles** (no behavior changes yet).
2. **Create base profiles** for NixOS and HM that mirror the current defaults.
3. **Switch one host** to profiles + app bundles (start with a NixOS host).
4. **Move existing apps** from scattered modules into bundles and remove duplicates.
5. **Trim host files** down to hardware + bundle/profile selection.

## Example wiring (proposal)

**NixOS host**

```nix
{ inputs, ... }: {
  imports = [
    ../../nixosModules
    ../../nixosModules/profiles/base.nix
    ../../nixosModules/profiles/desktop.nix
    ../../apps/bundles/core.nix
    ../../apps/bundles/dev.nix
  ];
}
```

**Home Manager**

```nix
{ ... }: {
  imports = [
    ../../homeManagerModules
    ../../homeManagerModules/profiles/base.nix
    ../../homeManagerModules/profiles/dev.nix
  ];
}
```

## Result

- Hosts become simple selectors.
- Apps live in one catalog with curated bundles.
- Adding apps becomes fast and predictable (one place to edit).
