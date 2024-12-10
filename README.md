<h1 align="center">
    mimvoid's little nix shells
</h1>
<p align="center">
    My personal collection of nix shell files for
    temporary packages, shell functions, and configuration files.
</p>

# Why?

There are certain tools I use repeatedly, but rarely enough that I don't want to keep
them in my user environment. For some, I may want settings and aliases that a simple
`nix-shell` or `nix shell` command cannot provide.

The solution? Nix can use `shell.nix` files and `devShells` to symlink files
and specify shell hooks. This repo is a collection of these files.

> [!NOTE]
> These shells are for my personal use cases. While I may listen to requests,
> this repository will likely be rather opinionated.
>
> I welcome anyone to create their own repo based on these files!

# Usage

The shells can be entered with or without flakes.

## With Flakes

At the root directory, use `nix develop` followed by the shell to enter.
The names of the `devShells` can be found in `flake.nix`.

**Example:**

`flake.nix`

```nix
{
  # ... other file contents ...

  outputs = { self, nixpkgs }:
    # ...
    devShells = forAllSystems ({ pkgs }: {
      "hello" = import ./hello/shell.nix { inherit pkgs; };
    });
  };
}
```

```sh
$ nix develop .#hello
```

To use a shell other than `bash`, you can do something like:

```sh
$ nix develop .#hello --command zsh
```

## With `nix-shell`

Enter the directory with the `shell.nix` file you want to use, and do `nix-shell`.

**Example:**

```sh
$ cd hello
$ nix-shell
```

# Making Nix Shells

## Aliases

Nix's `shellHook` can provide aliases, but since `devShells` are made in `bash`,
writing aliases in `shellHook` does not work for shells like `zsh`.

This is especially a problem if one uses [direnv](https://direnv.net) (e.g. with
[nix-direnv](https://github.com/nix-community/nix-direnv)), which automatically
drops you into your current shell.

However, there is a workaround: `pkgs.writeShellScriptBin`. This is a trivial builder
that writes a script file to `/nix/store/<store path>/bin/<file>`, and if included in
the shell's packages list, can be made available and executable for the user.

This repo stores these scripts in a set whose leaves can be included separately
in the shell's packages list.

**Example:**

`shell.nix`

```nix
{ pkgs ? import <nixpkgs> { } }:
let
  aliases = {
    uwu-hello = pkgs.writeShellScriptBin "uwu-hello"
      ''
        hello -g "hewwo?"
      '';

    custom-hello = pkgs.writeShellScriptBin "uwu-hello"
      ''
        hello -g "$@"
      '';
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    hello
    aliases.custom-hello
  ];
}
```

In the shell, `custom-hello "hi"` does `hello -g "hi"`, but `uwu-hello` is not a command.

## Configuration files

`shellHook` can symlink existing files to the specified location. For simplicity's
sake, that is what I do in this repo.

Alternatively, you can write something like this:

`shell.nix`

```nix
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  # ...

  shellHook =
    let
      config_file = builtins.toFile "config.toml"
        ''
          foo = "bar"

          [baz]
          hello = 1
        '';
    in
    ''
      ln -s ${config_file} ~/.config/example/config.toml
    '';
}
```

Or use the variations of `pkgs.writeTextFile`, `pkgs.writeText`, etc.
