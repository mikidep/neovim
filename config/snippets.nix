{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  options = with lib; {
    plugins.nvim-autopairs.exclude_filetypes = mkOption {
      type = types.attrsOf (types.listOf types.str);
      default = {};
    };
  };
  config = {
    plugins.luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
      };
      fromLua = [{paths = ../assets/snippets;}];
      fromSnipmate = [
        {
          lazyLoad = true;
        }
      ];
    };
    plugins.nvim-autopairs = let
      cfg = config.plugins.nvim-autopairs;
    in {
      enable = true;

      exclude_filetypes = {
        "'" = ["scheme" "lisp" "nix" "typst"];
      };
      settings = {
        ignored_next_char = ''[[]]'';
        enable_afterquote = false;
      };
      luaConfig.post =
        ''
          local Rule = require('nvim-autopairs.rule')
          local npairs = require('nvim-autopairs')
          local cond = require('nvim-autopairs.conds')

          npairs.add_rule(Rule("=", ";", "nix"))
          npairs.add_rule(Rule("${"''"}", "${"''"}","nix"))
          npairs.add_rule(Rule("$", "$", "typst"))
        ''
        + (
          let
            inherit (lib.strings) concatStringsSep;
            inherit (lib.attrsets) mapAttrsToList;
            inherit (lib.nixvim) toLuaObject;
          in
            concatStringsSep "\n" (
              mapAttrsToList (
                rule: langs: "npairs.get_rules(${toLuaObject rule})[1].not_filetypes = ${toLuaObject langs}"
              )
              cfg.exclude_filetypes
            )
        );
    };
    extraPlugins = with pkgs; [
      {
        plugin = vimUtils.buildVimPlugin {
          name = "telescope-luasnip.nvim";
          src = inputs.telescope-luasnip-nvim;
        };
        config = ''
          lua require('telescope').load_extension('luasnip')
        '';
      }
      vimPlugins.vim-snippets
    ];
    keymaps = [
      {
        key = "<C-l>";
        action = "<Plug>luasnip-jump-next<CR>";
        mode = ["i"];
      }
    ];
  };
}
