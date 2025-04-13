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
    settings.indent.enable = true;
    settings.highlight.enable = true;
    grammarPackages =
      pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars
      ++ [
        treesitter-openscad-grammar
      ];
    luaConfig.post = ''
      do
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.openscad = {
          install_info = {
            url = "${treesitter-openscad-grammar}",
            files = {"src/parser.c"},
            branch = "master",
            requires_generate_from_grammar = false,
          }
        }
      end
    '';
  };
  keymaps = [
    {
      key = "an";
      mode = ["x" "o"];
      action.__raw = ''require "nvim-treesitter.incremental_selection".node_incremental'';
      options.silent = true;
    }
    {
      key = "van";
      mode = "n";
      action.__raw = ''require "nvim-treesitter.incremental_selection".init_selection'';
      options.silent = true;
    }
    {
      key = "in";
      mode = ["x"];
      action.__raw = ''require "nvim-treesitter.incremental_selection".node_decremental'';
      options.silent = true;
    }
  ];
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
        # the ones below do not wor
        find = "%\\%(.-%\\%)";
        delete = "^(%\\%(%s*)().-(%s*%\\%()()$";
      };
    };
    settings.move_cursor = "sticky";
  };
  plugins.rainbow-delimiters = {
    enable = true;
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

  extraPackages = with pkgs; [
    ast-grep
  ];
  extraPlugins = with pkgs; [
    vimPlugins.telescope-sg
    treesitter-openscad-grammar
    vimPlugins.vim-indent-object
  ];
}
