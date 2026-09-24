local null_ls = require("null-ls")

local function qid_cmp(params)
  local ts = vim.treesitter
  local query = ts.query.parse("agda", "(qid) @qid")
  local buffer = params.bufnr
  local buf_highlighter = require('vim.treesitter.highlighter')
      .active[buffer]
  local line_count = vim.api.nvim_buf_line_count(buffer)

  local qidst = {}

  buf_highlighter.tree:for_each_tree(function(tstree, tree)
    if tree:lang() ~= 'agda' then
      return
    end

    local root = tstree:root()
    local iter = query:iter_captures(root, buffer, 0, line_count + 1)

    for _, node, _ in iter do
      local text = ts.get_node_text(node, buffer)
      qidst[text] = true
    end
  end)

  local items = {}

  for qid, _ in pairs(qidst) do
    if qid ~= params.word_to_complete then
      table.insert(items, {
        label = qid,
        insertText = qid
      })
    end
  end

  return {
    {
      items = items,
      isIncomplete = true,
    },
  }
end

return {
  cmp_source = {
    name = "agda_cmp",
    filetypes = { "agda" },
    method = { null_ls.methods.COMPLETION },
    generator = {
      fn = qid_cmp,
    },
    id = 1,
  }
  -- Fix this taking over Cornelis' GD
}
