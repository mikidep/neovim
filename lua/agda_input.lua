local jsonPath = vim.api.nvim_get_runtime_file("data/agda-symbols.json", false)[1]
local symtbl = vim.json.decode(vim.fn.join(vim.fn.readfile(jsonPath)))
local frecdir = vim.fn.stdpath('state') .. '/agda-input'

local MiniPick = require "mini.pick"
function source_with_prefix(prefix)
  local source = {
    name = "Agda symbols",
    items = vim.tbl_map(
      function(t)
        return {
          text = t[1] .. "   " .. t[2],
          sym = t[1]
        }
      end,
      symtbl
    ),
    match = function(_, inds, query)
      local needle = prefix .. table.concat(query)
      local f = function(i)
        local m = symtbl[i][2]:find(needle, 1, true)
        return m == 1
      end
      return vim.tbl_filter(f, inds)
    end,
    choose = function(it)
      -- We want some way to input the prefix
      local query = table.concat(MiniPick.get_picker_query())
      local feed = it.sym
      local flags = "t";
      if prefix ~= "" and query == ""
      then
        feed = prefix
        flags = "nt"
      end
      vim.fn.feedkeys(feed, flags)
    end,
  }
  return source
end

function picksym_cb(prefix)
  return function()
    local igc = vim.o.ignorecase
    vim.o.ignorecase = false
    MiniPick.start({
      source = source_with_prefix(prefix),
      mappings = {
        choose = "<Space>",
        toggle_info = "",
        toggle_preview = "",
        move_down = "<Tab>",
        move_up = "<S-Tab>"
      },
      window = {
        config = {
          width = 18,
          height = 9,
          relative = "cursor",
          row = 1,
          col = 0,
          anchor = "NW"
        }
      }
    })
    vim.o.ignorecase = igc
  end
end
