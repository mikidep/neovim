{
  pkgs,
  inputs,
  ...
}: {
  plugins.treesitter = {
    enable = true;
    settings.indent.enable = true;
    settings.highlight.enable = true;
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
              prev= "h",
              next = "l",
            }
          })
        EOF
      '';
    }
    vimPlugins.telescope-sg

    {
      plugin = vimPlugins.nvim-surround;
      config = ''
        lua << EOF
          require("nvim-surround").setup({
          })
        EOF
      '';
    }
  ];

  keymaps = [
    {
      key = "<leader>b";
      action = "<Plug>(nvim-surround-visual)";
      mode = ["v"];
      options.remap = true;
    }
  ];
}
