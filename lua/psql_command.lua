local Job = require('plenary.job')

local function psql_command(connection, query)
  local host, port

  if connection.tunnel then
    host = 'localhost'
    port = connection.tunnelPort
  else
    host = connection.host
    port = connection.port
  end

  local job = Job:new {
    command = '/usr/bin/psql',
    args = { 
      '-h',
      host,
      '-p',
      port,
      '-d',
      connection.database,
      '-U',
      connection.username,
      '-c',
      query
    },
    env = {
      ['PGPASSWORD'] = connection.password
    },

    on_stdout = function(err, data)
      if (err) then
        print('error', err)
      end
    end,
    on_stderr = function(err, data)
      if (err) then
        print('error', err)
      else
        print(data)
      end
    end
  }

  job:sync(60000)
  local result = job:result()
  return result
end

return psql_command

