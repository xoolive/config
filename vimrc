" Configuration file for vim
"
" When a reference is made to a tip #<tip> then you can access the reference at
" the following url:
"     <url:http://vim.sf.net/tips/tip.php?tip_id=<tip> >
"
"
" Useful plugins:
"    pathogen    https://github.com/tpope/vim-pathogen
"                For management of individually installed plugins in
"                ~/.vim/bundle (or ~\vimfiles\bundle), adding
"                `call pathogen#infect()` to your .vimrc prior to
"                `filetype plugin indent on` is the only other setup necessary.
"
"    ack.vim        https://github.com/mileszs/ack.vim.git
"    clang-complete git://github.com/Rip-Rip/clang_complete.git
"    ctrlp.vim      git://github.com/kien/ctrlp.vim.git
"    tabular        https://github.com/godlygeek/tabular.git
"    utl.vim        https://github.com/vim-scripts/utl.vim.git
"    vim-fugitive   https://github.com/tpope/vim-fugitive.git
"    vim-latex      git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex
"    Vim-R-plugin   https://github.com/jcfaria/Vim-R-plugin


let $VIMFILES=expand("$HOME/.vim")

syntax on                      " syntax hilighting
filetype plugin indent on      " enable filetype detection
behave xterm                   " do not use this stupid select mode


"
" set
"

set autoindent
set autochdir
"set backspace=2                " make backspace work normal
set backspace=indent,eol,start  " backspace through everything in insert mode
set backupdir=~/.tmp,.
set cinoptions=(0,t0,g0,:0,w1,W4
set clipboard=exclude:.*
set colorcolumn=80
set completeopt=menu,longest
" set cursorline                 " highlight current line
set dictionary+=/usr/share/dict/words
set directory=~/.tmp,.,/tmp
set display=lastline           " open the file where we last closed it
set encoding=utf8
set expandtab                  " replace tab by the appropriate nb of spaces
set fileformat=unix
" set foldenable
" set foldlevel=12
" set foldmethod=syntax
set grepprg=grep\ -nH\ $*      " necessary for latex
set hidden                     " ability to switch buffer without saving
set history=50
set hlsearch                   " highlight search result
set ignorecase                 " case insensitive searce
set incsearch                  " show the next search pattern as you type
set laststatus=2               " always show the status bar
set linespace=1                " set the space between two lines (gui only)
set list                       " we do what to show tabs, to ensure we get them
                               " out of my files
set listchars=tab:▸-,trail:-   " show tabs and trailing
set magic                      " use regexp in search
set matchtime=5                " how many tenths of a second to blink
                               " matching brackets for
" set mouse=a
set nocompatible               " no compatibility with legacy vi
set nostartofline              " do not move to the first char of line
" set omnifunc=cppomnicomplete#Complete
set ruler                      " show the line,column number
set scrolloff=3                " minimal number of lines around the cursor
set sessionoptions+=slash,unix
set shiftround                 " round indentation to a multiple of sw
set shiftwidth=4               " number of spaces for indentation
set shortmess+=I               " no intro message
set showcmd                    " display incomplete commands
set showmatch                  " briefly jump to the matching (,),[,],{,}
set smartcase                  " override ignorecase if uppercase present
set smarttab                   " tab in front of a blank line is rel to sw
set softtabstop=4              " number of spaces while editing
set statusline=%2*[%02n]%*\ %f\ (%L)\ %3*%(%m%)%4*%(%r%)%*\ %{fugitive#statusline()}%=\ \ <%l,%c%V>\ %P\
"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current
"              | | | | |  |   |      |  |     |       column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in
"              | | | | |  |   |          square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer

set suffixes+=.aux,.bak,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.info,.inx,.log
set suffixes+=.o,.obj,.out,.swp,.toc,~
set tabstop=4                  " what is a tab?
set tags=tags;/                " upward search, up to the root directory
set textwidth=80               " no more than 80 char per line
"set ttymouse=xterm2

set viminfo='20,\"50
set whichwrap=<,>,[,],h,l
set wildmode=list:full         " show list and try to complete

"
" iabbrev
"

iabbrev #i <C-R>=SmartInclude()<CR>
iabbrev #d #define
iabbrev \i \item

let mapleader   = ','
let g:mapleader = ','
let g:ackprg    = "ack-grep -H --nocolor --nogroup --column"
if has("mac")
    let g:ackprg    = "ack -H --nocolor --nogroup --column"
endif

"
" map
"
map & gqap

nmap <F5> :TlistToggle<CR>
nmap <F6> :TlistUpdate<CR>

nmap <Leader>b :CtrlPBuffer<CR>
nmap <Leader>d :Diff<CR>
nmap <Leader>e :e.<CR>
nmap <Leader>h :nohl<CR>
nmap <Leader>l :resize 60<CR>
nmap <Leader>N :Nl<CR>
nmap <Leader>n :RNl<CR>
nmap <Leader>r :vertical resize 80<CR>
nmap <Leader>s :source $MYVIMRC<CR>
nmap <Leader>u :Utl<CR>
nmap <Leader>L :winsize 80 45<CR>
nmap <Leader>w :winsize 161 45<CR>,r
nmap <Leader>v :edit $MYVIMRC<CR>

nmap <Leader>T :match ErrorMsg /.\+\s\+$/<CR>
nmap <Leader>8 :match ErrorMsg /\%>85v.\+/<CR>

" remove trailing spaces
nnoremap <Leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" select until last position
nnoremap <Leader>V V`]

" sort css
" nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

nmap <S-Tab> :bp<CR>
nmap <Tab> :bn<CR>

inoremap <C-Space> <C-R>=TriggerSnippet()<cr>
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

" no more than 85 lines
match ErrorMsg /\%>85v.\+/
" no trailing spaces
match MoreMsg /.\+\s\+$/

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

" popup
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
"
" command, autocommand
"

command! Diff call s:DiffWithSaved()
command! Nl if (&nu) <Bar> set nonu <Bar> else <Bar> set nu <Bar> endif
command! RNl if (&rnu) <Bar> set nornu <Bar> else <Bar> set rnu <Bar> endif

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
autocmd BufEnter *.R set comments+=b:#'
autocmd Syntax cpp call EnhanceSyntax()
autocmd BufEnter * set shiftwidth=4 tabstop=4
autocmd BufEnter *.c,*.cpp,*.h set shiftwidth=2 tabstop=2
autocmd BufEnter CMakeLists.txt set comments+=b:#' shiftwidth=2 tabstop=2


"
" let
"

" TagList Settings {
let Tlist_Auto_Open            = 0 " let the tag list open automagically
let Tlist_Compact_Format       = 1 " show small menu
let Tlist_Ctags_Cmd            = 'ctags -R --c-kinds                         = +p --fields = +aiS --extra = +q' " location of ctags
let Tlist_Enable_Fold_Column   = 0 " do show folding tree
let Tlist_Exist_OnlyWindow     = 1 " if you are the last, kill yourself
let Tlist_File_Fold_Auto_Close = 0 " fold closed other trees
let Tlist_Sort_Type            = "name" " order by
let Tlist_Use_Left_Window      = 1 " split to the right side of the screen
let Tlist_WinWidth             = 40 " 40 cols wide, so i can (almost always)
" }

let g:vimrplugin_conqueplugin      = 1
let g:vimrplugin_conquevsplit      = 1
let g:EnhCommentifyFirstLineMode   = "yes"
let g:EnhCommentifyPretty          = "yes"
let g:EnhCommentifyTraditionalMode = "no"
let g:EnhCommentifyUseSyntax       = "yes"
let g:Tex_DefaultTargetFormat      = 'pdf'

" Pathogen call for bundle directory
call pathogen#infect()

if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
  nmap <Leader>a_ :Tabularize /<-<CR>
  vmap <Leader>a_ :Tabularize /<-<CR>
endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction


if has("gui_running")
"     colorscheme evening
    colorscheme molokai
    au Colorscheme * call UpdateStatusLine()
    set lines=45
    if has("mac")
        set gfn=Menlo:h12
    elseif has("unix")
        set gfn=Monospace\ 11
    elseif has("win32")
        set gfn=Lucida_Console:h10:cANSI
        set lines=55
    endif
endif

