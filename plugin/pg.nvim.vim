" Guard to prevent loading twice
if exists('g:loaded_postgres_nvim') | finish | endif

" Apparently this is good practice, save coptions, clear them, and
" then restore them later
let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

function EnterBuffer()
  lua require 'pg-nvim'.EnterBuffer()
endfunction

" Run our plugin
command! PGConnectBuffer lua require 'pg-nvim'.ConnectBuffer()
command! PGPrintConnMap lua require 'pg-nvim'.PrintConnMap()
function! s:RunQueryOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'V'
    execute "normal!`<v`>y"
  else
    return
  endif

  lua require 'pg-nvim'.RunQuery(vim.api.nvim_eval('@@'))

  let @@ = saved_unnamed_register
endfunction
command! PGRunQuery call <SID>RunQueryOperator(visualmode())

augroup PgNvim
  autocmd!
  autocmd BufEnter * call EnterBuffer()
augroup END

" Here is where we restore the coptions
let &cpo = s:save_cpo " and restore after
unlet s:save_cpo
