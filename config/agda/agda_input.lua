local jsonPath = vim.api.nvim_get_runtime_file("data/agda-symbols.json", false)[1]
local symtbl = vim.json.decode(vim.fn.join(vim.fn.readfile(jsonPath)))
local frecdir = vim.fn.stdpath('state') .. '/agda-input'

function score(s, needle)
  if needle == "" then
    return string.len(s)
  end
  if s == "" then
    return 1000
  end
  local c = string.sub(needle, 1, 1)
  local i, _ = string.find(s, c, 1, true)
  if i == nil then
    return 1000
  else
    return i + 0.2 * score(string.sub(s, i + 1), string.sub(needle, 2))
  end
end

function scoreBoost(cs, needle)
  local boost = 0
  local boosted = {
    'λ',
    'β',
    '⋆'
  }
  if vim.tbl_contains(boosted, cs[1]) then
    boost = 0.5
  end
  return score(cs[2], needle) - boost
end

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
      local ff = function(i)
        local si = symtbl[i][2]
        return score(si, needle) < 1000
      end
      local sf = function(i, j)
        local si = symtbl[i]
        local sj = symtbl[j]
        return scoreBoost(si, needle) < scoreBoost(sj, needle)
      end
      local filtd = vim.tbl_filter(ff, inds)
      table.sort(filtd, sf)
      return filtd
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
