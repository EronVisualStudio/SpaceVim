let s:search_tools = {}
let s:search_tools.namespace = {
      \ 'rg' : 'r',
      \ 'ag' : 'a',
      \ 'pt' : 't',
      \ 'ack' : 'k',
      \ 'grep' : 'g',
      \ }
let s:search_tools.a = {}
let s:search_tools.a.command = 'ag'
let s:search_tools.a.default_opts =
      \ [
      \ '-i', '--vimgrep', '--hidden', '--ignore',
      \ '.hg', '-ignore', '.svn', '--ignore', '.git', '--ignore', '.bzr',
      \ ]
let s:search_tools.a.recursive_opt = []

let s:search_tools.t = {}
let s:search_tools.t.command = 'pt'
let s:search_tools.t.default_opts = ['--nogroup', '--nocolor']
let s:search_tools.t.recursive_opt = []

let s:search_tools.r = {}
let s:search_tools.r.command = 'rg'
let s:search_tools.r.default_opts = ['--hidden', '--no-heading', '--vimgrep', '-S']
let s:search_tools.r.recursive_opt = []

let s:search_tools.k = {}
let s:search_tools.k.command = 'ack'
let s:search_tools.k.default_opts = ['-i', '--no-heading', '--no-color', '-k', '-H']
let s:search_tools.k.recursive_opt = []

let s:search_tools.g = {}
let s:search_tools.g.command = 'grep'
let s:search_tools.g.default_opts = ['-inHr']
let s:search_tools.g.recursive_opt = ['.']

function! SpaceVim#mapping#search#grep(key, scope)
  let cmd = s:search_tools[a:key]['command']
  let opt = s:search_tools[a:key]['default_opts']
  let ropt = s:search_tools[a:key]['recursive_opt']
  if a:scope ==# 'b'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'files':'@buffers',
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'B'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'files':'@buffers',
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'p'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'P'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'f'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'dir' : input('arbitrary dir:', '', 'dir'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'F'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'dir' : input('arbitrary dir:', '', 'dir'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  endif
endfunction

function! SpaceVim#mapping#search#default_tool()
  if !has_key(s:search_tools, 'default_exe')
    for t in g:spacevim_search_tools
      if executable(t)
        let s:search_tools.default_exe = t
        let key = s:search_tools.namespace[t]
        let s:search_tools.default_opt = s:search_tools[key]['default_opts']
        let s:search_tools.default_ropt = s:search_tools[key]['recursive_opt']
        break
      endif
    endfor
  endif
  return [s:search_tools.default_exe, s:search_tools.default_opt, s:search_tools.default_ropt]
endfunction
