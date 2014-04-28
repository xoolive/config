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


if has("win32")
    let $VIMFILES=expand("D:\xolive\Documents\github\config\vim")
end

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" required first
Bundle 'gmarik/vundle'

" Bundle 'Lokaltog/vim-powerline.git'
Bundle 'bling/vim-airline'
Bundle 'Rip-Rip/clang_complete.git'
Bundle 'davidhalter/jedi-vim'
Bundle 'godlygeek/tabular.git'
Bundle 'jcfaria/Vim-R-plugin.git'
Bundle 'kien/ctrlp.vim.git'
Bundle 'klen/python-mode.git'
Bundle 'majutsushi/tagbar.git'
Bundle 'mileszs/ack.vim.git'
Bundle 'scrooloose/syntastic.git'
Bundle 'tpope/vim-eunuch.git'
Bundle 'tpope/vim-fugitive.git'
Bundle 'tpope/vim-surround.git'
Bundle 'vim-scripts/Conque-Shell.git'
Bundle 'vim-scripts/VimClojure.git'
Bundle 'vim-scripts/omlet.vim.git'
Bundle 'vim-scripts/utl.vim.git'

if has("mac")
    Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
endif

syntax on                      " syntax hilighting
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on      " enable filetype detection
behave xterm                   " do not use this stupid select mode


"
" set
"

set autoindent
set autochdir
set backspace=indent,eol,start  " backspace through everything in insert mode
set backupdir=~/.tmp,.
set cinoptions=(0,t0,g0,:0,w1,W4
set clipboard=exclude:.*
set colorcolumn=81
set complete+=t
set completeopt=menu,longest
" set cursorline                 " highlight current line
set dictionary+=/usr/share/dict/words
set directory=~/.tmp,.,/tmp
set display=lastline           " open the file where we last closed it
set encoding=utf8
set expandtab                  " replace tab by the appropriate nb of spaces
set fileformat=unix
set grepprg=grep\ -nH\ $*      " necessary for latex
set guioptions=a               " no menus, no icons
set hidden                     " ability to switch buffer without saving
set history=50
set hlsearch                   " highlight search result
set ignorecase                 " case insensitive searce
set incsearch                  " show the next search pattern as you type
set laststatus=2               " always show the status bar
set linespace=1                " set the space between two lines (gui only)
set list                       " we do what to show tabs, to ensure we get them
                               " out of my files
set listchars=tab:▸-,trail:-,eol:¬,extends:❯,precedes:❮ " show tabs and trailing
set magic                      " use regexp in search
set matchtime=5                " how many tenths of a second to blink
                               " matching brackets for
set nocompatible               " no compatibility with legacy vi
"set nostartofline              " do not move to the first char of line
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


" Better to put it around the top
let mapleader                 = ','
let maplocalleader            = ','
let g:mapleader               = ','

"
" map
"

map & gqap

" Calling accidentally help is so annoying!!
map <F1> <Esc>
imap <F1> <Esc>

nmap <F2> :TagbarToggle<CR>
nmap <Leader>b :CtrlPBuffer<CR>
nmap <Leader>d :DiffSaved<CR>
nmap <Leader>D :DiffSVN<CR>
nmap <Leader>e :Errors<CR>
nmap <Leader>h :nohl<CR>
nmap <Leader>l :resize 60<CR>
nmap <Leader>N :Nl<CR>
nmap <Leader>n :RNl<CR>
nmap <Leader>r :vertical resize 81<CR>
nmap <Leader>s :source $MYVIMRC<CR>
nmap <Leader>u :Utl<CR>
nmap <Leader>v :edit $MYVIMRC<CR>

if has("unix")
    nmap <Leader>1 :winsize 81 50<CR>
    nmap <Leader>2 :winsize 121 50<CR>
    nmap <Leader>3 :winsize 161 50<CR>
elseif has("win32")
    nmap <Leader>1 :winsize 81 55<CR>
    nmap <Leader>2 :winsize 121 55<CR>
    nmap <Leader>3 :winsize 161 55<CR>
endif

" remove trailing spaces
nnoremap <Leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" select until last position
nnoremap <Leader>V V`]

" sort css
" nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" can't work anymore without those
nmap <S-Tab> :bp<CR>
nmap <Tab>   :bn<CR>

" play with tabularize
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a_ :Tabularize /<-<CR>
vmap <Leader>a_ :Tabularize /<-<CR>

inoremap <silent><Bar>   <Bar><Esc>:call <SID>align()<CR>a

" play with completion
inoremap <C-Space> <C-R>=TriggerSnippet()<cr>
inoremap <C-L> <C-X><C-L>
inoremap <S-Tab> <C-R>=InsertTabWrapper("forward")<cr>
inoremap <Tab> <C-R>=InsertTabWrapper("backward")<cr>

" remap basic moves
vnoremap <BS> d
vnoremap <Down> j
vnoremap <End> $
vnoremap <Home> ^
vnoremap <Left> h
vnoremap <PageDown> 30j
vnoremap <PageUp> 30k
vnoremap <Right> l
vnoremap <Up> k

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Highlight characters over column 85
match MoreMsg /\(.\+\s\+$\|\%>85v.\+\)/

"
" function
"

"  TIP #1030
function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

function! s:DiffWithSVNCheckedOut()
  let filetype=&ft
  diffthis
  vnew | exe "%!svn cat " . expand("#:p:h")
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSVN call s:DiffWithSVNCheckedOut()

" Add highlighting for function definition in C++
function! EnhanceSyntax()
    syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
    hi def link cppFuncDef Special
endfunction

" Convenient for #include in c/cpp
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

" Tabularize related
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

"
" command, autocommand
"

command! Nl if (&nu) <Bar> set nonu <Bar> else <Bar> set nu <Bar> endif
command! RNl if (&rnu) <Bar> set nornu <Bar> else <Bar> set rnu <Bar> endif

" Jump to last position in the file, see <url:vimhelp:last-position-jump>
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \ | exe "normal g`\"" | endif

autocmd BufEnter *               set  shiftwidth=4 tabstop=4
autocmd BufEnter *.R             set  comments+=b:#'
autocmd BufEnter *.c,*.cpp,*.h   set  shiftwidth=2 tabstop=2
autocmd BufEnter *.gamme         set  filetype=gamme
autocmd BufEnter SCons*,*.scons  set  filetype=scons
autocmd BufEnter *.i             set  filetype=cpp
autocmd BufEnter *.java          set  cindent
autocmd BufEnter CMakeLists.txt  set  comments+=b:#' shiftwidth=2 tabstop=2
autocmd BufWinEnter,BufNewFile * silent tabo           " I hate tabs!
autocmd Syntax cpp               call EnhanceSyntax()
autocmd Syntax ocaml             set shiftwidth=2 tabstop=2
autocmd Syntax clojure           set shiftwidth=2 tabstop=2

"
" let
"

let g:vimrplugin_conqueplugin      = 1
let g:vimrplugin_conquevsplit      = 0

let g:EnhCommentifyFirstLineMode   = "yes"
let g:EnhCommentifyPretty          = "yes"
let g:EnhCommentifyTraditionalMode = "no"
let g:EnhCommentifyUseSyntax       = "yes"

let g:pymode_breakpoint   = 0
let g:pymode_lint_write   = 1
let g:pymode_folding      = 0
let g:pymode_options      = 0
let g:pymode_lint_checker = "pyflakes,pep8,mccabe"

" let g:pymode_lint_ignore                    = "E501"
" let g:pymode_rope_always_show_complete_menu = 1

let g:tex_flavor                   = 'latex'
let g:Tex_DefaultTargetFormat      = 'pdf'

let g:syntastic_cpp_config_file    = '.clang_complete'
let g:syntastic_tex_checkers       = ['chktex']  " lacheck = big pile of shit
" Warning 1: Command terminated with space
" Warning 6: No italic correction (`\/') found
" Warning 8: Wrong length of dash
" Warning 11: ... should be \ldots
let g:syntastic_tex_chktex_args    = "-n1 -n6 -n8 -n11"

let g:syntastic_error_symbol       = '✗'
let g:syntastic_warning_symbol     = '⚠'

let g:clang_snippets               = 0
let g:clang_snippets_engine        = ''
if has("mac")
    let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
endif

let omlet_indent                   = 2
let omlet_indent_let               = 0
let omlet_indent_match             = 0
let omlet_indent_function          = 0

if has("mac")

    let g:ackprg              = "ack -H --nocolor --nogroup --column"
    let g:Tex_ViewRule_pdf    = 'Preview'
    let g:Tex_CompileRule_pdf = 'xelatex'

elseif has("unix")

    let g:ackprg              = "ack-grep -H --nocolor --nogroup --column"

elseif has("win32")

    let g:ackprg              = "ack.bat -H --nocolor --nogroup --column"
    let tagbar_ctags_bin      = 'ctags'

endif

let g:airline_powerline_fonts = 1
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols = {}
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
let g:airline_theme='powerlineish'


if has("gui_running")

    colorscheme molokai

    if has("mac")
        set gfn=Menlo:h12
        set gfn=Menlo\ for\ Powerline:h12
        set lines=50
    elseif has("unix")
        set gfn=Monospace\ 11
        set gfn=DejaVuSans\ Mono\ for\ Powerline\ 11
        set lines=50
    elseif has("win32")
        set gfn=Lucida_Console:h10:cANSI
        set gfn=Consolas\ for\ Powerline\ FixedD:h11:cDEFAULT
        set lines=55
    endif

endif

