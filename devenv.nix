{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  packages = [
    pkgs.git
    pkgs.lua-language-server
    pkgs.selene
    pkgs.stylua
  ];

  scripts.typecheck.exec = "lua-language-server --check=. --checklevel=Warning";

  languages.lua.enable = true;

  git-hooks.hooks = {
    selene.enable = true;
    stylua.enable = true;
  };
}
