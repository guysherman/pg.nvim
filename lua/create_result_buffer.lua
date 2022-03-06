local Split = require('nui.split')

local function create_result_buffer(input_win)
  local split = Split({
    position = 'bottom',
    size = '50%'
  })
  split:mount()
  vim.api.nvim_set_current_win(input_win)
  return split
end

return create_result_buffer
