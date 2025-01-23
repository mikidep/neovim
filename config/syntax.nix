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
    settings.incremental_selection = {
      enable = true;
      keymaps = {
        init_selection = "van";
        node_incremental = "an";
      };
    };
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
  # extraFiles."queries/agda/rainbow-delimiters.scm".source = ../assets/queries/agda/rainbow-delimiters.scm;

  extraPackages = with pkgs; [
    ast-grep
  ];
  extraPlugins = with pkgs; [
    vimPlugins.telescope-sg
    treesitter-openscad-grammar
  ];
}
