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
          local tshjkl = require 'tshjkl'
          tshjkl.setup({
            keymaps = {
              toggle = "<Space>v",
              parent = "k",
              child = "j",
              prev = "h",
              next = "l",
            }
          })
        EOF
      '';
    }
    vimPlugins.telescope-sg
    vimPlugins.nvim-surround
  ];
}
