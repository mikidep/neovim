{lib, ...}: {
  plugins.mini-pick = {
    enable = true;
  };
  highlightOverride."MiniPickMatchCurrent".link = "PmenuSel";
  plugins.mini-clue = {
    enable = true;
    settings.clues = [
      (lib.nixvim.mkRaw ''require("mini.clue").gen_clues.windows()'')
    ];
    settings.triggers = [
      {
        keys = "<Leader>";
        mode = "n";
      }
      {
        keys = "<C-w>";
        mode = "n";
      }
      {
        keys = "g";
        mode = "n";
      }
    ];
  };
  plugins.mini-completion = {
    enable = true;
    luaConfig.post = ''
      local imap_expr = function(lhs, rhs)
        vim.keymap.set('i', lhs, rhs, { expr = true })
      end
      imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
      imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
    '';
  };
  plugins.mini-ai = {
    enable = true;
    settings = {
      mappings = {
        around_next = "";
        inside_next = "";
        around_last = "";
        inside_last = "";
      };
      custom_textobjects = {
        n.__raw = ''
          function()
            froml, fromc, tol, toc = vim.treesitter.get_node_range(
              vim.treesitter.get_node()
            )
            return {
              from = { line = froml + 1, col = fromc + 1 },
              to = { line = tol + 1, col = toc }
            }
          end
        '';
        b = [["%b()" "%b[]" "%b{}" "%b⟨⟩" "%b⟦⟧"] "^.().*().$"];
        h = ["{!().*()!}"];
      };
    };
  };
  plugins.mini-diff.enable = true;
  plugins.mini-tabline.enable = true;
}
