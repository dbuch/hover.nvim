local async = require('hover.async')

local function enabled()
  return vim.diagnostic ~= nil
end

local function comp_severity(a, b)
  return a['severity'] < b['severity']
end


local function process(ldiag)
  if not ldiag then
    return
  end

  table.sort(ldiag, comp_severity)

  for _, val in ipairs(ldiag) do
    vim.pretty_print(val)
  end

  return ldiag
end

local execute = async.void(function(done)
  local _, lnum = vim.api.nvim_win_get_cursor(0)
  local ldiag = vim.diagnostic.get(0, {
    lnum = lnum,
  })

  local results = process(ldiag)
  if not results then
    results = { 'no line diagnostic' }
  end
  done(results and { lines = results })
end)

require('hover').register {
  name = 'Diagnostics',
  priority = 50,
  enabled = enabled,
  execute = execute,
}
