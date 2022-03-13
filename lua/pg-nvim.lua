local api = vim.api
local Menu = require('nui.menu')
local event = require("nui.utils.autocmd").event
local get_connection_files = require('./get_connection_files')
local create_result_buffer = require('./create_result_buffer')
local psql_command = require('./psql_command')
local psql_tunnel = require('./psql_tunnel')

local settings = {
  state_dir = '/home/guy/.local/state/pg.nvim',
  gpg_exe = '/usr/bin/gpg',
}

local connection_map = {}

local popup_options = {
  relative = "win",
  position = '50%',
  size = {
    width =' 25%',
    height = '25%',
  },
  border = {
    style = 'rounded',
    text = {
      top = "Select Connection",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:SpecialChar",
  }
}

local function connect_buffer()
  local current_buffer = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()

  local conn_files = get_connection_files(settings.state_dir, settings)

  local menu_lines = {}
  for f in pairs(conn_files) do
    local file = conn_files[f]
    table.insert(menu_lines, Menu.item(file.name, file))
  end

  local menu = Menu(popup_options, {
    lines = menu_lines,
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      print("CLOSED")
    end,
    on_submit = function(item)
      local split = create_result_buffer(current_win)
      local tunnel

      if item.tunnel then
        tunnel = psql_tunnel(item)
      end

      connection_map[current_buffer] = {
        connection = item,
        split = split,
        tunnel = tunnel,
      }

      print("SUBMITTED", vim.inspect(item))
    end,
  })

  menu:mount()
  menu:on(event.BufLeave, menu.menu_props.on_close, { once = true })
end

local function print_connection_map()
  print('Connection Map', vim.inspect(connection_map))
end

local function run_query(query)
  local current_buffer = vim.api.nvim_get_current_buf()
  local connection_data = connection_map[current_buffer]
  local output = psql_command(connection_data.connection, query)
  vim.api.nvim_buf_set_lines(connection_data.split.bufnr, 0, -1, false, output)
  vim.api.nvim_set_current_win(connection_data.split.winid)
end

return {
  ConnectBuffer = connect_buffer,
  PrintConnMap = print_connection_map,
  RunQuery = run_query
}