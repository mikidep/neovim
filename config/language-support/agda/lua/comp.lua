function convert_comp()
  local ts = vim.treesitter
  local q = ts.query.get("agda", "agda-comp")
  local tree = ts.get_parser():parse()[1]

  local caps = {}
  local bufnr = vim.api.nvim_get_current_buf()
  local sr = nil
  local sc = nil
  local er = nil
  local ec = nil

  local found = false
  for _, match, _
  in q:iter_matches(tree:root(), bufnr, 0, -1) do
    found = true
    for id, nodes in pairs(match) do
      local name = q.captures[id]
      for _, node in ipairs(nodes) do
        caps[name] = node
      end
    end
    break
  end

  if not found then return end

  sr, sc, er, ec = ts.get_node_range(caps["main"])

  local p = ts.get_node_text(caps["p"], bufnr)
  local q = ts.get_node_text(caps["q"], bufnr)

  local rpls = "(" .. p .. " ∙ " .. q .. ")"
  local rpl = vim.split(rpls, "\n")

  vim.api.nvim_buf_set_text(bufnr, sr, sc, er, ec, rpl)
  convert_comp()
end
