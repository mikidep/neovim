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
    # package = pkgs.vimPlugins.nvim-surround.overrideAttrs rec {
    #   version = "v3.1.6";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "kylechui";
    #     repo = "nvim-surround";
    #     rev = version;
    #     sha256 = "sha256-sbLPR1x3lP8Dg+neFeO0elnHFT55rCY3F1uGGtU1nAU=";
    #   };
    # };
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
    (
      vimUtils.buildVimPlugin {
        name = "ns-textobject";
        src = inputs.ns-textobject-nvim;
        doCheck = false;
      }
    )
  ];
  extraConfigLuaPost = ''
    require "ns-textobject".setup {
      disable_builtin_mapping = {
        enabled = true,
        -- list of char which shouldn't mapping by auto_mapping
        chars = { "b", "B", "t", "T", "`", "'", '"', "{", "}", "(", ")", "[", "]", "<", ">" },
      },
    }
  '';
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

    {
      key = "m";
      mode = ["x" "o"];
      action.__raw = ''require("flash").treesitter'';
      options.silent = true;
    }
    {
      key = "[m";
      mode = ["n" "x" "o"];
      action.__raw = ''function () require("flash").treesitter({ jump = { pos = "start" }, label = { before = true, after = false } }) end'';
      options.silent = true;
    }
    {
      key = "]m";
      mode = ["n" "x" "o"];
      action.__raw = ''function () require("flash").treesitter({ jump = { pos = "end" }, label = { before = false, after = true } }) end'';
      options.silent = true;
    }
  ];
}
