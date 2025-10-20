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
    (
      vimUtils.buildVimPlugin {
        name = "nvim-treehopper";
        src = inputs.nvim-treehopper;
        doCheck = false;
      }
    )
  ];
  extraConfigLuaPost = ''
    require "ns-textobject".setup {
      disable_builtin_mapping = {
        enabled = true,
        -- list of char which shouldn't mapping by auto_mapping
        chars = { "t", "T" },
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
      mode = "x";
      key = "L";
      action = "<cmd>STSSelectNextSiblingNode<cr>";
    }
    {
      mode = "x";
      key = "H";
      action = "<cmd>STSSelectPrevSiblingNode<cr>";
    }
    {
      mode = "x";
      key = "K";
      action = "<cmd>STSSelectParentNode<cr>";
    }
    {
      mode = "x";
      key = "J";
      action = "<cmd>STSSelectChildNode<cr>";
    }
    {
      mode = "x";
      key = "<A-h>";
      action = "<cmd>STSSwapPrevVisual<cr>";
    }
    {
      mode = "x";
      key = "<A-l>";
      action = "<cmd>STSSwapNextVisual<cr>";
    }
    {
      key = "m";
      mode = ["x" "o"];
      action = '':<C-U>lua require("flash").treesitter()'';
      options.silent = true;
    }
    {
      key = "[m";
      mode = ["n" "x" "o"];
      action = '':<C-U>lua require("tsht").move({ side = "start" })<CR>'';
      options.silent = true;
    }
    {
      key = "]m";
      mode = ["n" "x" "o"];
      action = '':<C-U>lua require("tsht").move({ side = "end" })<CR>'';
      options.silent = true;
    }
  ];
}
