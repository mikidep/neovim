{
  pkgs,
  inputs,
  ...
}: {
  files."ftplugin/tex.lua" = {
    plugins.vimtex = {
      enable = true;
      texlivePackage = null;
      settings.view_method = "zathura";
    };
    opts = {
      tw = 80;
    };
    globals.latex_view_general_viewer = "zathura";
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "luasnip-latex-snippets.nvim";
        src = inputs.luasnip-latex-snippets-nvim;
        doCheck = false;
      })
      # (pkgs.vimUtils.buildVimPlugin {
      #   name = "ltex-utils.nvim";
      #   src = inputs.ltex-utils-nvim;
      #   doCheck = false;
      # })
    ];
  };
  plugins.treesitter.settings.highlight.disable = ["latex"];

  plugins.lsp.servers.ltex = {
    enable = true;
    # onAttach.function = ''
    #   require("ltex-utils").on_attach(bufnr)
    # '';
    settings.configurationTarget = {
      dictionary = "user";
      disabledRules = "user";
      hiddenFalsePositives = "user";
    };
  };
  plugins.lsp.servers.texlab = {
    enable = true;
    extraOptions.settings = {
      texlab.build.onSave = true;
      texlab.build.forwardSearchAfter = true;
      texlab.forwardSearch.executable = "zathura";
      texlab.forwardSearch.args = ["--synctex-forward" "%l:1:%f" "%p"];
    };
  };
  plugins.nvim-autopairs = {
    luaConfig.post = ''
      local Rule = require('nvim-autopairs.rule')
      local npairs = require('nvim-autopairs')

      npairs.add_rule(Rule("\\(", "\\)", "tex"))
      npairs.add_rule(Rule("\\[", "\\]", "tex"))
    '';

    exclude_filetypes = {
      "'" = ["tex"];
      "`" = ["tex"];
    };
  };
}
