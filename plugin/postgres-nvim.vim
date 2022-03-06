" Guard to prevent loading twice
if exists('g:loaded_postgres_nvim') | finish | endif

" Apparently this is good practice, save coptions, clear them, and
" then restore them later
let s:save_cpo = &cpo " save user coptions
set cpo&vim " reset them to defaults

" Run our plugin
command! PGConnectBuffer lua require 'postgres_nvim'.ConnectBuffer()
command! PGPrintConnMap lua require 'postgres_nvim'.PrintConnMap()

" Here is where we restore the coptions
let &cpo = s:save_cpo " and restore after
unlet s:save_cpo
