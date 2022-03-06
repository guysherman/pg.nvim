local scandir = require('plenary.scandir')
local json = vim.json

local function load_file(path)
  local file = io.open(path, 'r')
  if file then
    local result = {}
    local file_text = file:read('*a')
    result = json.decode(file_text)
    io.close(file)
    return result
  end

  return nil
end

local function get_connection_files(state_dir)
  local connection_files = {}
  local files = scandir.scan_dir(state_dir, { add_dirs=false })
  for i, _ in pairs(files) do
    local file = files[i]
    local connection_settings = load_file(file)
    table.insert(connection_files, connection_settings)
  end
  return connection_files
end

return get_connection_files
