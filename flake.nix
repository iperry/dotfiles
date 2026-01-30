{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.buildEnv {
          name = "tools";
          paths = with pkgs; [
            awscli2
            delta
            fd
            fzf
            neovim-unwrapped
            nixd
            nixfmt
            nodePackages.prettier
            nodejs
            ripgrep
            rustup
            uv
          ];
        };
      }
    );
}
