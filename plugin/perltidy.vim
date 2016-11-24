"==============================================================================
" perltidy.vim
" Last Change: 18 Nov 2016
" Maintainer: Shawn Sorichetti <shawn at coloredblocks.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in  all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"==============================================================================

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:project_perltidy = ''
if !exists('g:perltidy_config')
  let g:perltidy_config = ""
endif

if !exists('g:perltidy')
  let g:perltidy = "perltidy"
endif

command -range=% -nargs=* PerlTidy <line1>,<line2> call DoPerlTidy()

function DoPerlTidy() range
  let l = line(".")
  let c = col(".")
  let s:perltidy_config = ''
  let perl_line = ''
  if g:perltidy_config ==# ''
    let s:project_perltidy = perltidy#find_perltidy()
    if s:project_perltidy !=# ''
      let s:perltidy_config = '-pro=' . s:project_perltidy
    endif
  else
    let s:perltidy_config = '-pro=' . g:perltidy_config
  endif

  if a:firstline == a:lastline
    execute "!" . g:perltidy . " " . s:perltidy_config . " " . bufname("%")
    call cursor(l, c)
  else
    let perl_line = getline(a:firstline, a:lastline)
    let results = split(system(g:perltidy . " -opt " . s:perltidy_config, perl_line),'\v\n')
    if len(results) > a:lastline - a:firstline
      let i = 0
      let needed = len(results) - (a:lastline - a:firstline)
      while i < needed - 1
        call append(a:firstline, "")
        let i = i + 1
      endwhile
    endif
    if len(results) < a:lastline - a:firstline
      let needed = (a:lastline - a:firstline) - len(results)
      execute ":" . a:firstline ."," . (a:firstline + needed) . "delete _"
    endif
    call setline(a:firstline, results)
  endif

endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
