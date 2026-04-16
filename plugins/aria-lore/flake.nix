{
  description = "Aria Lore - image generation and lore production tools for the Aria project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells = with pkgs; {
          default = mkShell {
            nativeBuildInputs = [
              curl
              jq
              coreutils
              libwebp
            ];

            shellHook = ''
              echo "Aria Lore shell loaded"
              echo "Scripts: $(cd "$(dirname "$0")" && pwd)/scripts"
              export PATH="${builtins.toString ./.}/scripts:$PATH"
              if [ -z "''${GEMINI_API_KEY:-}" ]; then
                echo ""
                echo "Don't forget to export GEMINI_API_KEY!"
              fi
            '';
          };
        };
      }
    );
}
