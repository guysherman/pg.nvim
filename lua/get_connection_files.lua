local scandir = require('plenary.scandir')
local Job = require('plenary.job')
local json = vim.json

local function load_encrypted_file(path, settings)
  local job = Job:new {
    command = settings.gpg_exe,
    args = {
      '-q',
      '--decrypt',
      path
    },
  }

  job:sync(60000)
  local result = table.concat(job:result(), '\n')
  return result
end

local function load_plain_file(path)
  local file = io.open(path, 'r')
  if file then
    local file_text = file:read('*a')
    io.close(file)
    return file_text
  end

  return nil
end

local function load_file(path, settings)
  local file_text = load_encrypted_file(path, settings)
  print('decrypt', file_text)
  local status, connection_data = pcall(function()
    return json.decode(file_text)
  end)

  if status then
    return connection_data
  else
    file_text = load_plain_file(path)
  end

  status, connection_data = pcall(function()
    return json.decode(file_text)
  end)

  if status then
    return connection_data
  end

  return nil
end

local function get_connection_files(state_dir, settings)
  local connection_files = {}
  local files = scandir.scan_dir(state_dir, { add_dirs=false })
  for i, _ in pairs(files) do
    local file = files[i]
    local connection_settings = load_file(file, settings)
    table.insert(connection_files, connection_settings)
  end
  return connection_files
end

return get_connection_files
