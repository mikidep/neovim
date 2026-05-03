{
  pkgs,
  inputs,
  ...
}: let
  treesitter-openscad-grammar = pkgs.tree-sitter.buildGrammar {
    language = "openscad";
    version = "master";
    src = inputs.tree-sitter-openscad;
    meta.homepage = "https://github.com/bollian/tree-sitter-openscad";
  };
in {
  plugins.treesitter = {
    enable = true;
    grammarPackages =
      pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars
      ++ [
        treesitter-openscad-grammar
      ];
    # TODO: hacky
    luaConfig.post = ''
      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        pattern = '*',
        callback = function()
          if vim.bo.filetype ~= "agda"
            and vim.bo.filetype ~= "tex"
          then
            pcall(vim.treesitter.start)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

    '';
  };

  plugins.nvim-surround = {
    enable = true;
    settings.surrounds = {
      "h" = {
        add = ["{! " " !}"];
        find = "%{!.-!%}";
        delete = "^(%{!%s*)().-(%s*!%})()$";
      };
      "m" = {
        add = ["\\(" "\\)"];
        # the ones below do not work
        find = "%\\%(.-%\\%)";
        delete = "^(%\\%(%s*)().-(%s*%\\%()()$";
      };
    };
    settings.move_cursor = "sticky";
    settings.indent_lines = false;
  };
  plugins.rainbow-delimiters = {
    enable = true;
    settings = {
      query.agda = "rainbow-delimiters";
      highlight = [
        "RainbowDelimiterRed"
        "RainbowDelimiterYellow"
        "RainbowDelimiterBlue"
        "RainbowDelimiterGreen"
        "RainbowDelimiterViolet"
        "RainbowDelimiterCyan"
      ];
    };
  };

  extraPackages = with pkgs; [
    ast-grep
  ];
  extraPlugins = with pkgs; [
    vimPlugins.telescope-sg
    treesitter-openscad-grammar
    vimPlugins.vim-indent-object
  ];

  keymaps = [
    {
      key = "m";
      mode = ["x" "o"];
      action.__raw = ''require("flash").treesitter'';
      options.silent = true;
    }
  ];
}
