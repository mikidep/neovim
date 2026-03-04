local jsonPath = vim.api.nvim_get_runtime_file("data/agda-symbols.json", false)[1]
local symtbl = vim.json.decode(vim.fn.join(vim.fn.readfile(jsonPath)))
local frecdir = vim.fn.stdpath('state') .. '/agda-input'

-- local frecpath = frecdir .. '/frecency.dat'
--
-- vim.fn.mkdir(frecdir, "p")
-- local fuzzy_impl = require 'blink.cmp.fuzzy.rust'
-- local fuzzydb = fuzzy_impl.init_db(frecpath, false)
-- vim.api.nvim_create_autocmd('VimLeavePre', {
--   callback = fuzzydb.implementation.destroy_db,
-- })
-- fuzzydb.has_init_db = true


local MiniPick = require "mini.pick"
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
    local needle = table.concat(query)
    local f = function(i)
      local m = symtbl[i][2]:find(needle, 1, true)
      return m == 1
    end
    return vim.tbl_filter(f, inds)
  end,
  choose = function(it) vim.fn.feedkeys(it.sym) end,
}

local picksym = function()
  local igc = vim.o.ignorecase
  vim.o.ignorecase = false
  MiniPick.start({
    source = source,
    mappings = {
      choose = "<Space>"
    }
  })
  vim.o.ignorecase = igc
end

-- return {
--   picksym = picksym
-- }
