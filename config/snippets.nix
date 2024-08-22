{
  pkgs,
  inputs,
  ...
}: {
  plugins.luasnip = {
    enable = true;
    extraConfig = {
      enable_autosnippets = true;
    };
    fromLua = [{paths = ../assets/snippets;}];
  };
  extraPlugins = with pkgs; [
    {
      plugin = vimPlugins.ultimate-autopair-nvim;
      config = ''
        lua << EOF
          local ua = require 'ultimate-autopair'
          ua.setup(ua.extend_default {
            {"=", ";", ft={"nix"}},
            tabout = {
              enable = true,
              hopout = true
            }
          })
        EOF
      '';
    }
    {
      plugin = vimUtils.buildVimPlugin {
        name = "telescope-luasnip.nvim";
        src = inputs.telescope-luasnip-nvim;
      };
      config = ''
        lua << EOF
          require('telescope').load_extension('luasnip')
        EOF
      '';
    }
  ];
}
