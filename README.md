# postgres-nvim

A plugin for neovim that lets you play with postgres databases. I created this
because I wanted something like it, and I wanted to have a crack at building a
neovim plugin myself. You should also take a look at [vim-dadbod](https://github.com/tpope/vim-dadbod),
because Tim is a legend and actually knows what he is doing (also I believe it
works in vim as well).

![Basic Features of pg.nvim](/doc/pg-nvim-basic.gif)

## Installation

I use [vim-plug](https://github.com/junegunn/vim-plug) and my installation looks like this:

```
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'guysherman/pg.nvim'
```

I have set up a couple of keybinds:

```
vnoremap <leader>qq :<c-u>exec "PGRunQuery"<cr>
nnoremap <leader>qc :PGConnectBuffer<cr>
```


## Features
### Basic features

* Connect a buffer to a database
* Execute queries from that buffer and see the results in a companion buffer
* Can decrypt connection settings before use
* Supports ssh tunnels
* When you switch between connected buffers, it updates the result window with the correct result buffer
* If you close the result window while in a different file (ie a non SQL file), and then navigate back to
a conneted buffer, it re-opens the result window

![Managing Buffers](/doc/pg-nvim-buffers.gif)

### Coming eventually...
* Configure some of the settings
* SSL
* Persistent sessions
* Easy schema navigation

### Possibilities for the future
* Other databases?
* Script schema definition out to new buffer?

## Usage

### Basics

Connection files are stored in `$HOME/.local/state/pg.nvim`. They are json files and they conform to the following schema:

```
{
  // Mandatory
  "name": "some name for the ui",
  "host": "pg.example.com",
  "port": 5432,
  "username": "example-user",
  "password": "example-password-123",
  "database": "example-db-name",
}
```

When you run the command `:PGConnectBuffer` the plugin will scan the connection
directory and list the connections you have stored there. Use `j/k` to navigate
the list, and use `Enter` to select an item.

![Connecting a Buffer](/doc/pg-nvim-connect-buffer.png)

A split will open.

In the original buffer you can now type SQL queries, or PSQL commands. Use
visual selection to select the query/command you would like to execute then run:
`:<c-u>exec "PGRunQuery"<cr>`. I bind this to a handy key.

The results will show up in the lower split.

![Run a query](/doc/pg-nvim-run-query.png)

### SSH Tunnels

To use an SSH tunnel, add some extra properties to your connection file as
detailed below:

```
{
  // Mandatory
  "name": "some name for the ui",
  "host": "pg.example.com",
  "port": 5432,
  "username": "example-user",
  "password": "example-password-123",
  "database": "example-db-name",
  // Optional, only needed for tunnels
  "tunnel": "tunnel.example.",
  "tunnelPort": 42124,
  "tunnelSshPort": 22,
  "tunnelUser": "example-user",
  "tunnelKeyFile": "/home/guy/.ssh/example-user"
}
```

The tunnel will be opened when you connect your buffer, and will be closed when
you exit neovim. Make sure to set a suitably unique value for `tunnelPort` so
that it doesn't clash with any local servers, or other tunnels. You need to be
using an ssh key to authenticate with your tunnel host, and at present I have
not implemented a way to get the passphrase from you, so if you have one your
ssh agent needs to prompt you outside the terminal.


### Encrypted connection files

Obviously, storing passwords in plain text on your machine is a bit weak, so we
support encrypting those files with gpg. Ther are a couple of caveats though:

* You must use a passphrase (or it would be pointless)
* Your system must prompt you for the passphrase outside of the terminal somehow.

This second point is important. The plugin executes the `gpg` process with a
`plenary.job` but I haven't made any affordance for getting the passphrase from
the user. On my machine I am using a gpg key-pair, and polkit prompts me for the
passphrase (and then stores it in the system keyring for a while). On mac you
need to install gpg-tools, rather than just gpg. For Windows I have no idea.

I created a gpg key with: `gpg --full-gen-key`, and then I encrypt my connection
files as follows:

```
gpg --encrypt --recipient <my key email address> --output <out file name> <in file name>
```

I put the encrypted file in the `~/.local/state/pg.nvim` directory and delete the
plain text file.
