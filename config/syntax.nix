{
  pkgs,
  inputs',
  ...
}: {
  plugins.treesitter = {
    enable = true;
    indent = true;
    incrementalSelection.enable = true;
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin inputs'.nvim-treehopper)
  ];

  keymaps = [
    {
      key = "<leader>s";
      action = ''require 'tsht'.nodes'';
      lua = true;
    }
  ];
}
