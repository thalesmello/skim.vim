" Copyright (c) 2015 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

" Modified by Jinzhou Zhang(lotabout@gmail.com)

let s:cpo_save = &cpo
set cpo&vim

let g:skim#vim#default_layout = {'down': '~40%'}

function! s:defs(commands)
  let prefix = get(g:, 'skim_command_prefix', '')
  if prefix =~# '^[^A-Z]'
    echoerr 'g:skim_command_prefix must start with an uppercase letter'
    return
  endif
  for command in a:commands
    execute substitute(command, '\ze\C[A-Z]', prefix, '')
  endfor
endfunction

call s:defs([
\'command! -bang -nargs=? -complete=dir Files  call skim#vim#files(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang -nargs=? GitFiles             call skim#vim#gitfiles(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang -nargs=? GFiles               call skim#vim#gitfiles(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang Buffers                       call skim#vim#buffers(skim#vim#layout(<bang>0))',
\'command! -bang -nargs=* Lines                call skim#vim#lines(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang -nargs=* BLines               call skim#vim#buffer_lines(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang Colors                        call skim#vim#colors(skim#vim#layout(<bang>0))',
\'command! -bang -nargs=1 -complete=dir Locate call skim#vim#locate(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang -nargs=* Ag                   call skim#vim#ag(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang -nargs=* Tags                 call skim#vim#tags(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang -nargs=* BTags                call skim#vim#buffer_tags(<q-args>, skim#vim#layout(<bang>0))',
\'command! -bang Snippets                      call skim#vim#snippets(skim#vim#layout(<bang>0))',
\'command! -bang Commands                      call skim#vim#commands(skim#vim#layout(<bang>0))',
\'command! -bang Marks                         call skim#vim#marks(skim#vim#layout(<bang>0))',
\'command! -bang Helptags                      call skim#vim#helptags(skim#vim#layout(<bang>0))',
\'command! -bang Windows                       call skim#vim#windows(skim#vim#layout(<bang>0))',
\'command! -bang Commits                       call skim#vim#commits(skim#vim#layout(<bang>0))',
\'command! -bang BCommits                      call skim#vim#buffer_commits(skim#vim#layout(<bang>0))',
\'command! -bang Maps                          call skim#vim#maps("n", skim#vim#layout(<bang>0))',
\'command! -bang Filetypes                     call skim#vim#filetypes(skim#vim#layout(<bang>0))',
\'command! -bang -nargs=* History              call s:history(<q-args>, <bang>0)'])

function! s:history(arg, bang)
  let bang = a:bang || a:arg[len(a:arg)-1] == '!'
  let ext = skim#vim#layout(bang)
  if a:arg[0] == ':'
    call skim#vim#command_history(ext)
  elseif a:arg[0] == '/'
    call skim#vim#search_history(ext)
  else
    call skim#vim#history(ext)
  endif
endfunction

function! skim#complete(...)
  return call('skim#vim#complete', a:000)
endfunction

if has('nvim') && get(g:, 'skim_nvim_statusline', 1)
  function! s:skim_restore_colors()
    if exists('#User#skimStatusLine')
      doautocmd User skimStatusLine
    else
      if $TERM !~ "256color"
        highlight skim1 ctermfg=1 ctermbg=8 guifg=#E12672 guibg=#565656
        highlight skim2 ctermfg=2 ctermbg=8 guifg=#BCDDBD guibg=#565656
        highlight skim3 ctermfg=7 ctermbg=8 guifg=#D9D9D9 guibg=#565656
      else
        highlight skim1 ctermfg=161 ctermbg=238 guifg=#E12672 guibg=#565656
        highlight skim2 ctermfg=151 ctermbg=238 guifg=#BCDDBD guibg=#565656
        highlight skim3 ctermfg=252 ctermbg=238 guifg=#D9D9D9 guibg=#565656
      endif
      setlocal statusline=%#skim1#\ >\ %#skim2#sk%#skim3#im
    endif
  endfunction

  function! s:skim_nvim_term()
    if get(w:, 'airline_active', 0)
      let w:airline_disabled = 1
      autocmd BufWinLeave <buffer> let w:airline_disabled = 0
    endif
    autocmd WinEnter,ColorScheme <buffer> call s:skim_restore_colors()

    setlocal nospell
    call s:skim_restore_colors()
  endfunction

  augroup _skim_statusline
    autocmd!
    autocmd FileType skim call s:skim_nvim_term()
  augroup END
endif

let g:skim#vim#buffers = {}
augroup skim_buffers
  autocmd!
  if exists('*reltimefloat')
    autocmd BufWinEnter,WinEnter * let g:skim#vim#buffers[bufnr('')] = reltimefloat(reltime())
  else
    autocmd BufWinEnter,WinEnter * let g:skim#vim#buffers[bufnr('')] = localtime()
  endif
  autocmd BufDelete * silent! call remove(g:skim#vim#buffers, expand('<abuf>'))
augroup END

inoremap <expr> <plug>(skim-complete-word)        skim#vim#complete#word()
inoremap <expr> <plug>(skim-complete-path)        skim#vim#complete#path("find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'")
inoremap <expr> <plug>(skim-complete-file)        skim#vim#complete#path("find . -path '*/\.*' -prune -o -type f -print -o -type l -print \| sed 's:^..::'")
inoremap <expr> <plug>(skim-complete-file-ag)     skim#vim#complete#path("ag -l -g ''")
inoremap <expr> <plug>(skim-complete-line)        skim#vim#complete#line()
inoremap <expr> <plug>(skim-complete-buffer-line) skim#vim#complete#buffer_line()

nnoremap <silent> <plug>(skim-maps-n) :<c-u>call skim#vim#maps('n', skim#vim#layout(0))<cr>
inoremap <silent> <plug>(skim-maps-i) <c-o>:call skim#vim#maps('i', skim#vim#layout(0))<cr>
xnoremap <silent> <plug>(skim-maps-x) :<c-u>call skim#vim#maps('x', skim#vim#layout(0))<cr>
onoremap <silent> <plug>(skim-maps-o) <c-c>:<c-u>call skim#vim#maps('o', skim#vim#layout(0))<cr>

let &cpo = s:cpo_save
unlet s:cpo_save

