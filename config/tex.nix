{
  pkgs,
  inputs,
  ...
}: {
  plugins.vimtex = {
    enable = true;
    texlivePackage = null;
    settings.view_method = "zathura";
  };

  autoCmd = [
    {
      command = "setl tw=80";
      event = ["BufRead" "BufNewFile"];
      pattern = [
        "*.tex"
      ];
    }
  ];

  globals.latex_view_general_viewer = "zathura";
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "cmp-vimtex";
      src = inputs.cmp-vimtex;
      doCheck = false;
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "luasnip-latex-snippets.nvim";
      src = inputs.luasnip-latex-snippets-nvim;
      doCheck = false;
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "ltex-utils.nvim";
      src = inputs.ltex-utils-nvim;
      doCheck = false;
    })
  ];
  plugins.cmp.filetype.tex.sources = [
    {name = "luasnip";}
    {name = "vimtex";}
    {name = "luasnip";}
    {name = "path";}
  ];
  plugins.lsp.servers.ltex = {
    enable = true;
    onAttach.function = ''
      require("ltex-utils").on_attach(bufnr)
    '';
  };
  plugins.nvim-autopairs = {
    luaConfig.post = ''
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')

      npairs.add_rule(Rule("\\(", "\\)", "tex"))
      npairs.add_rule(Rule("\\[", "\\]", "tex"))
      npairs.add_rule(Rule("{", "}", "tex"))
    '';

    exclude_filetypes = {
      "'" = ["tex"];
      "`" = ["tex"];
    };
  };
}
