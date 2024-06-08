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
  extraPlugins = with pkgs; [
    {
      plugin = vimUtils.buildVimPlugin {
        name = "tshjkl.nvim";
        src = inputs.tshjkl;
      };
      config = ''
        lua << EOF
          require 'tshjkl'.setup({

          })
        EOF
      '';
    }
    vimPlugins.telescope-sg
    vimPlugins.nvim-surround
  ];
}
