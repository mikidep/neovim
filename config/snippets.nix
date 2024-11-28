{
  pkgs,
  inputs,
  ...
}: {
  plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
    };
    fromLua = [{paths = ../assets/snippets;}];
  };
  plugins.nvim-autopairs = {
    enable = true;
    luaConfig.post = ''
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')
      local cond = require('nvim-autopairs.conds')

      npairs.add_rule(Rule("=", ";", "nix"))

      npairs.add_rule(Rule("${"''"}", "${"''"}","nix"))
      npairs.get_rules("'")[1].not_filetypes = { "scheme", "lisp", "agda", "nix" }
    '';
  };
  extraPlugins = with pkgs; [
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
