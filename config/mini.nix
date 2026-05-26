{lib, ...}: {
  plugins.mini-pick = {
    enable = true;
  };
  plugins.mini-comment.enable = true;
  plugins.mini-cmdline = {
    enable = false;
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
      search_method = "cover";
      mappings = {
        around_next = "";
        inside_next = "";
        around_last = "";
        inside_last = "";
      };
      custom_textobjects = {
        n.__raw = ''
          function()
            local getRng = function(node)
              local range = { node:range() }
              -- Following adapted from:
              -- github.com/folke/flash.nvim rev. fcea7f
              -- lua/flash/plugins/treesitter.lua
              -- line 60 onwards
              local line_count = vim.fn.getpos("$")[2]
              local frange = {
                from = {
                  line = range[1] + 1,
                  col = range[2] + 1
                },
                to = {
                  line = range[3] + 1,
                  col = range[4]
                },
              }
              if frange.to.line == line_count
                or frange.to.col == 0 then
                frange.to.line = line_count - 1
                frange.to.col = vim.fn.strwidth(
                  vim.fn.getline(frange.to.line)) + 1
              end
              return frange
            end

            local node = vim.treesitter.get_node()

            local res = {}

            while node ~= nil do
              table.insert(res, getRng(node))
              node = node:parent()
            end

            return res
          end
        '';
        b = [["%b()" "%b[]" "%b{}"] "^.().*().$"];
        h = ["{!().*()!}"];
      };
    };
  };
  plugins.mini-diff.enable = true;
  plugins.mini-diff.settings.mappings = {
    apply = "";
    goto_first = "";
    goto_last = "";
    goto_next = "";
    goto_prev = "";
    reset = "";
    textobject = "";
  };
  plugins.mini-tabline.enable = true;
}
