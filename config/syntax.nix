{
  pkgs,
  inputs,
  ...
}: {
  plugins.treesitter = {
    enable = true;
    indent = true;
    incrementalSelection.enable = true;
  };
  extraPackages = with pkgs; [
    ast-grep
  ];
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-treehopper";
      src = inputs.nvim-treehopper;
    })
    {
      plugin = pkgs.vimUtils.buildVimPlugin {
        name = "tshjkl.nvim";
        src = inputs.tshjkl;
      };
      config = ''
        lua << EOF
          require'tshjkl'.setup({

          })
        EOF
      '';
    }
    pkgs.vimPlugins.telescope-sg
  ];

  keymaps = [
    {
      key = "<leader>s";
      action = ''require 'tsht'.nodes'';
      lua = true;
    }
  ];
}
