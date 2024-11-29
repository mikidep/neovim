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
  plugins.nvim-surround = {
    enable = true;
    settings.surrounds = {
      "h" = {
        add = ["{! " " !}"];
        find = "%{!.-!%}";
        delete = "^(%{!%s*)().-(%s*!%})()$";
      };
    };
  };
  plugins.rainbow-delimiters = {
    enable = true;
    query.agda = "rainbow-delimiters";
  };
  extraFiles."queries/agda/rainbow-delimiters.scm".source = ../assets/queries/agda/rainbow-delimiters.scm;

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
    # {
    #   plugin = vimPlugins.rainbow;
    #   config = ''
    #     let g:rainbow_active = 1
    #   '';
    # }
  ];
}
