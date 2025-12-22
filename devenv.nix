{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  packages = [
    pkgs.git
    pkgs.selene
    pkgs.stylua
  ];

  languages.lua.enable = true;

  git-hooks.hooks = {
    selene.enable = true;
    stylua.enable = true;
  };
}
