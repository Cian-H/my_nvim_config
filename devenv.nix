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
    pkgs.prek
    pkgs.selene
    pkgs.stylua
    pkgs.luaPackages.fennel
    pkgs.fennel-ls
    pkgs.fnlfmt
  ];

  scripts = {
    typecheck.exec = "lua-language-server --check=. --checklevel=Warning";

    fnlcheck.exec = ''
      files=$(git ls-files '*.fnl')
      if [ -n "$files" ]; then
        fnlfmt --check $files
      else
        echo "No Fennel files to format."
      fi
    '';

    smoketest.exec = ''
      PROFILE_DIR="$PWD/.devenv/test-profile"
      rm -rf "$PROFILE_DIR/nvim"
      mkdir -p "$PROFILE_DIR/nvim" "$PROFILE_DIR/data" "$PROFILE_DIR/state" "$PROFILE_DIR/cache"
      find "$PWD" -maxdepth 1 ! -name ".git" ! -name ".devenv" ! -name ".direnv" ! -name "devenv.lock" ! -name "devenv.nix" ! -name "devenv.yaml" ! -name ".envrc" -exec cp -r {} "$PROFILE_DIR/nvim/" \;

      XDG_CONFIG_HOME="$PROFILE_DIR" \
      XDG_DATA_HOME="$PROFILE_DIR/data" \
      XDG_STATE_HOME="$PROFILE_DIR/state" \
      XDG_CACHE_HOME="$PROFILE_DIR/cache" \
      nvim --headless -c 'q'
    '';

    test-drive.exec = ''
      PROFILE_DIR="$PWD/.devenv/test-profile"
      rm -rf "$PROFILE_DIR/nvim"
      mkdir -p "$PROFILE_DIR/nvim" "$PROFILE_DIR/data" "$PROFILE_DIR/state" "$PROFILE_DIR/cache"

      # Copy config files and folders to local sandbox config path
      find "$PWD" -maxdepth 1 ! -name ".git" ! -name ".devenv" ! -name ".direnv" ! -name "devenv.lock" ! -name "devenv.nix" ! -name "devenv.yaml" ! -name ".envrc" -exec cp -r {} "$PROFILE_DIR/nvim/" \;

      echo "Starting test-drive of Neovim configuration in isolated sandbox..."
      echo "Caches, plugins, and state will be saved to: $PROFILE_DIR"

      XDG_CONFIG_HOME="$PROFILE_DIR" \
      XDG_DATA_HOME="$PROFILE_DIR/data" \
      XDG_STATE_HOME="$PROFILE_DIR/state" \
      XDG_CACHE_HOME="$PROFILE_DIR/cache" \
      nvim "$@"
    '';
  };

  languages.lua.enable = true;
  languages.python.enable = true;


  git-hooks.hooks = {
    selene.enable = true;
    stylua.enable = true;
    fnlfmt = {
      enable = true;
      name = "fnlfmt";
      entry = "${pkgs.fnlfmt}/bin/fnlfmt --check";
      files = "\\.fnl$";
    };
  };
}
