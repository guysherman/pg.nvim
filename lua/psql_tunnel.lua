local Job = require('plenary.job')

local function check_tunnel(connection)
  local tunnel_open = false
  local check = Job:new {
    command = '/usr/bin/psql',
    args = {
      '-h',
      'localhost',
      '-p',
      connection.tunnelPort,
      '-d',
      connection.database,
      '-U',
      connection.username,
      '-c',
      'SELECT 1'
    },
    env = {
      ['PGPASSWORD'] = connection.password,
    },
    on_stdout = function(err, _)
      if err ~= true then
        tunnel_open = true
      end
    end
  }

  check:sync()
  return tunnel_open
end

local function psql_tunnel(connection)
    local tunnel = Job:new {
      command = 'ssh',
      args = {
        '-L',
        string.format('%d:%s:%d', connection.tunnelPort, connection.host, connection.port),
        --'-N',
        '-i',
        connection.tunnelKeyFile,
        '-p',
        connection.tunnelSshPort,
        string.format('%s@%s', connection.tunnelUser, connection.tunnel)
      },
      on_stderr = function(err, data)
        if (err) then
          print('error', err)
        else
          print(data)
        end
      end
    }

    tunnel:start()
    vim.wait(
      2000,
      function()
        return check_tunnel(connection)
      end,
      100,
      false)
    return tunnel
end

return psql_tunnel
