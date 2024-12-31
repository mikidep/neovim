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
  plugins.nvim-surround = {
    enable = true;
    settings.surrounds = {
      "h" = {
        add = ["{! " " !}"];
        find = "%{!.-!%}";
        delete = "^(%{!%s*)().-(%s*!%})()$";
      };
    };
    settings.move_cursor = "sticky";
  };
  plugins.rainbow-delimiters = {
    enable = true;
    query.agda = "rainbow-delimiters";
  };
  # extraFiles."queries/agda/rainbow-delimiters.scm".source = ../assets/queries/agda/rainbow-delimiters.scm;

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
    treesitter-openscad-grammar
  ];
}
