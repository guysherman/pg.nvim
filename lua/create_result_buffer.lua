local function create_result_buffer(input_win)
  vim.cmd('bel split')
  local winid = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(input_win)
  return winid
end

return create_result_buffer
