local Job = require('plenary.job')

  --local connection_settings = connection_file.load(path)

  --local env_vars = {}
  --table.insert(env_vars, string.format('PGPASSWORD=%s', connection_settings.password))

  --job = Job:new {
    ----command = '/usr/bin/psql',
    ----args = { '-h', 'localhost', '-U', connection_settings.username, '-c', '\\dn' },
    ----env = env_vars,

    --on_stdout = function(err, data)
      --if (err) then
        --print('error', err)
      --else
        --print(data)
      --end
    --end,
    --on_stderr = function(_, data)
      --if (err) then
        --print('error', err)
      --else
        --print(data)
      --end
    --end,
  --}
  --job:start()
  --job:send('Foo\n')
  --job:send('Bar\n')
  --job:send('Baz\n')
  --job:shutdown()

