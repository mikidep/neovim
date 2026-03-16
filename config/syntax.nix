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
    indent.enable = true;
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
    # {
    #   key = "an";
    #   mode = ["x" "o"];
    #   action.__raw = ''require "nvim-treesitter.incremental_selection".node_incremental'';
    #   options.silent = true;
    # }
    # {
    #   key = "van";
    #   mode = "n";
    #   action.__raw = ''require "nvim-treesitter.incremental_selection".init_selection'';
    #   options.silent = true;
    # }
    # {
    #   key = "in";
    #   mode = ["x"];
    #   action.__raw = ''require "nvim-treesitter.incremental_selection".node_decremental'';
    #   options.silent = true;
    # }

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
