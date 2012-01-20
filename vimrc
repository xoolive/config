" Configuration file for vim
" 
" When a reference is made to a tip #<tip> then you can access the reference at
" the following url:
"     <url:http://vim.sf.net/tips/tip.php?tip_id=<tip> >
" 
"


let $VIMFILES=expand("$HOME/.vim")

syntax on                      " syntax hilighting
filetype plugin indent on      " enable filetype detection
behave xterm                   " do not use this stupid select mode

if has("gui")
    colorscheme evening
    au Colorscheme * call UpdateStatusLine()
endif

"
" set
"

set autoindent
set backspace=2                " make backspace work normal
set backupdir=~/.tmp,.
set cinoptions=(0,t0,g0,:0,w1,W4 
set clipboard=exclude:.*
set dictionary+=/usr/share/dict/words
set directory=~/.tmp,.,/tmp
set display=lastline           " open the file where we last closed it
set encoding=utf8
set expandtab                  " replace tab by the appropriate nb of spaces
set fileformat=unix
set foldenable
set foldlevel=12
set foldmethod=indent
set grepprg=grep\ -nH\ $*      " necessary for latex
set gfn=Menlo:h12
set hidden                     " do not close hidden buffer
set history=50
set hlsearch                   " highlight search result
set ignorecase                 " case insensitive search
set incsearch                  " show the next search pattern as you type
set laststatus=2               " always show the status bar
set linespace=1                " set the space between two lines (gui only)
set nocompatible               " do not behave like vi
set nolist                     " do not show void characters
set nostartofline              " do not move to the first char of line
set ruler                      " show the line,column number
set scrolloff=3                " minimal number of lines around the cursor
set sessionoptions+=slash,unix
set shiftround                 " round indentation to a multiple of sw
set shiftwidth=4               " number of spaces for indentation
set shortmess+=I               " no intro message
set showcmd                    " info in status line
set showmatch                  " briefly jump to the matching (,),[,],{,}
set smartcase                  " override ignorecase if uppercase present
set smarttab                   " tab in front of a blank line is rel to sw
set softtabstop=4              " number of spaces while editing
set statusline=%2*[%02n]%*\ %f\ %3*%(%m%)%4*%(%r%)%*%=%b\ 0x%B\ \ <%l,%c%V>\ %P
set suffixes+=.aux,.bak,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.info,.inx,.log
set suffixes+=.o,.obj,.out,.swp,.toc,~
set tabstop=4                  " what is a tab?
set tags=tags;/                " upward search, up to the root directory
set textwidth=80               " no more than 80 char per line
set viminfo='20,\"50
set whichwrap=<,>,[,],h,l
set wildmode=list:full         " show list and try to complete

"
" iabbrev
"

iabbrev #i <C-R>=SmartInclude()<CR>
iabbrev #d #define
iabbrev \i \item


"
" map
"
map & gqap

nmap ,f :A<CR>
nmap ,h :nohl<CR>
nmap ,p :set invpaste<CR>
nmap ,s :source $MYVIMRC<CR> 
nmap ,v :edit $MYVIMRC<CR>
nmap <S-Tab> :bp<CR>
nmap <Tab> :bn<CR>

inoremap <C-L> <C-X><C-L>
inoremap <S-Tab> <C-R>=InsertTabWrapper("forward")<cr>
inoremap <Tab> <C-R>=InsertTabWrapper("backward")<cr>

vnoremap <BS> d
vnoremap <Down> j
vnoremap <End> $
vnoremap <Home> ^
vnoremap <Left> h
vnoremap <PageDown> 30j
vnoremap <PageUp> 30k
vnoremap <Right> l
vnoremap <Up> k

" search forward (*) and backward (#)
"  TIP #780

vmap <silent> * :<C-U>let old_reg=@"<cr>
      \gvy/<C-R><C-R>=substitute(
      \escape(@", '\\/.*$^~[]'), "[ \t\n]\\+", '\\_s\\+', 'g')<CR><CR>
      \:let @"=old_reg<cr>
vmap <silent> # :<C-U>let old_reg=@"<cr>
      \gvy?<C-R><C-R>=substitute(
      \escape(@", '\\?.*$^~[]'), "[ \t\n]\\+", '\\_s\\+', 'g')<CR><CR>
      \:let @"=old_reg<cr>

"
" function
"

"  TIP #1030
function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    " new for horizontal split
    new | r # | normal 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

function! s:DiffWithCheckedOut()
    let filetype=&ft
    diffthis
    " new for horizontal split
    vnew | r !cvs up -pr BASE #
    normal 1Gd6d
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

function! UpdateStatusLine()
    hi User2 cterm=NONE ctermfg=yellow ctermbg=black guifg=yellow guibg=black
    hi User3 cterm=NONE ctermfg=black ctermbg=red guifg=black guibg=red
    hi User4 cterm=NONE ctermfg=green ctermbg=black guifg=green guibg=black
endfunction

" Add highlighting for function definition in C++
function! EnhanceSyntax()
    syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
    hi def link cppFuncDef Special
endfunction

function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction

function! SmartInclude()
    let next = nr2char( getchar( 0 ) )
    if next == '"'
        return "#include \".h\"\<Left>\<Left>\<Left>"
    endif
    if next == '>'
        return "#include <>\<Left>"
    endif
    return "#include <>\<Left>"
endfunction

"
" command, autocommand
"

command! Diff call s:DiffWithSaved()
command! CVSDiff call s:DiffWithCheckedOut()
command! Nl if (&nu) <Bar> set nonu <Bar> else <Bar> set nu <Bar> endif
command! ToHtml runtime! syntax/2html.vim


" Tags navigation: jump to the file under cursor with <CR>, except in the
" quickfix window (see <url:vimhelp:quickfix>)
au BufReadPost * map <buffer> <CR> g<C-]>
au BufReadPost quickfix unmap <buffer> <CR>
au BufReadPost quickfix  setlocal modifiable
     \ | let g:qf_tmp=@/
     \ | silent %s/^/\=line(".")." "/
     \ | let @/=g:qf_tmp
     \ | setlocal nomodifiable
" Jump to last position in the file, see <url:vimhelp:last-position-jump>
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") 
    \ | exe "normal g`\"" | endif

autocmd BufEnter *.java set cindent
autocmd BufEnter *.i setf cpp
autocmd Syntax cpp call EnhanceSyntax()

"
" let 
"

let Tlist_Ctags_Cmd="ctags"

let g:EnhCommentifyFirstLineMode = "yes"
let g:EnhCommentifyPretty = "yes"
let g:EnhCommentifyTraditionalMode = "no"
let g:EnhCommentifyUseSyntax = "yes"
let g:mapleader = "`"
let g:miniBufExplorerMoreThanOne = 3

let html_use_css = 1
let java_highlight_java_lang_ids = 1
let python_highlight_all = 1

if $SHELL =~ '/\(sh\|csh\|bash\|tcsh\|zsh\)$'
  let s:path = system("echo /sw/bin:/sw/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/usr/local/bin:/Users/xo/.bin:/usr/X11R6/bin:$PATH")
  let $PATH =s:path
endif

"
" Other misc
" 

set <Home>=[1~
set <Insert>=[2~
set <Del>=[3~
set <End>=[4~
set <PageUp>=[5~
set <PageDown>=[6~
set <F1>=[11~
set <F2>=[12~
set <F3>=[13~
set <F4>=[14~
set <F5>=[15~
set <F6>=[17~
set <F7>=[18~
set <F8>=[19~
set <F9>=[20~
set <F10>=[21~
set <F11>=[23~
set <F12>=[24~
set <S-Tab>=[Z
map!  <BS>
" keypad
set <kEnter>=OM
set <kDivide>=OQ
set <kMultiply>=OR
set <kMinus>=OS
set <kPlus>=Ol
set <kPoint>=On
set <k0>=Op
set <k1>=Oq
set <k2>=Or
set <k3>=Os
set <k4>=Ot
set <k5>=Ou
set <k6>=Ov
set <k7>=Ow
set <k8>=Ox
set <k9>=Oy

