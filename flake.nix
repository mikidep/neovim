{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    midnight-nvim = {
      url = "github:dasupradyumna/midnight.nvim";
      flake = false;
    };
    floating-help-nvim = {
      url = "github:Tyler-Barham/floating-help.nvim";
      flake = false;
    };
    nvfs = {
      url = "github:LunarVim/Neovim-from-scratch";
      flake = false;
    };
    cmp-vimtex = {
      url = "github:micangl/cmp-vimtex";
      flake = false;
    };
    marp-nvim = {
      url = "github:mpas/marp-nvim";
      flake = false;
    };
    scrolleof-nvim = {
      url = "github:Aasim-A/scrollEOF.nvim";
      flake = false;
    };
    telescope-luasnip-nvim = {
      url = "github:benfowler/telescope-luasnip.nvim";
      flake = false;
    };
    telescope-git-file-history-nvim = {
      url = "github:isak102/telescope-git-file-history.nvim";
      flake = false;
    };
    guihua-lua = {
      url = "github:ray-x/guihua.lua";
      flake = false;
    };
    cmp-agda-symbols = {
      url = "github:Arkissa/cmp-agda-symbols";
      flake = false;
    };
    luasnip-latex-snippets-nvim = {
      url = "github:evesdropper/luasnip-latex-snippets.nvim";
      flake = false;
    };
    tree-sitter-openscad = {
      url = "github:bollian/tree-sitter-openscad";
      flake = false;
    };
    ltex-utils-nvim = {
      url = "github:jhofscheier/ltex-utils.nvim";
      flake = false;
    };
    ns-textobject-nvim = {
      url = "github:XXiaoA/ns-textobject.nvim";
      flake = false;
    };
    nvim-treehopper = {
      url = "github:mfussenegger/nvim-treehopper";
      flake = false;
    };
    agda-symbols = {
      url = "github:4e554c4c/agda-symbols";
      flake = false;
    };
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        inputs',
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit pkgs;
          module = import ./config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            # inherit (inputs) foo;
            inherit inputs inputs';
          };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
        };
      };
    };
}
