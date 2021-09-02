" Configuration file for vim

"
" When a reference is made to a tip #<tip> then you can access the reference at
" the following url: <url:http://vim.sf.net/tips/tip.php?tip_id=<tip> >
"

set encoding=utf8
scriptencoding utf-8

if has('win32')
    let $VIMFILES=expand('D:\xolive\Documents\github\config\vim')
end

set nocompatible    " no compatibility with legacy vi
filetype off

set runtimepath+=~/.vim/bundle/vundle/
call vundle#begin()

" required first
Plugin 'gmarik/vundle'

" Look and feel
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'junegunn/seoul256.vim'

Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'              " fzf is the new ctrl-p
Plugin 'rking/ag.vim'                  " Support for ag (ag is the new ack)

Plugin 'majutsushi/tagbar'             " Add the tagbar
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" -- tpope --
"
Plugin 'tpope/vim-eunuch.git'          " Access to Remove, Rename, Mkdir, etc.
Plugin 'tpope/vim-surround.git'        " Add support to s in csb[, etc.
Plugin 'tpope/vim-repeat.git'          " I need to repeat those!
Plugin 'tpope/vim-fugitive.git'        " Working with git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-speeddating'         " Increment dates

" -- misc. --
Plugin 'vim-scripts/utl.vim'           " urls
Plugin 'godlygeek/tabular.git'         " csv-like alignment

" -- programming --
"
let g:polyglot_disabled = ['latex']

Plugin 'sheerun/vim-polyglot'          " support for maaaany languages
Plugin 'dense-analysis/ale'            " async version of syntastic
Plugin 'ambv/black'

Plugin 'vim-scripts/a.vim'             " Good old switch :A for C/C++

" Python specific: working with Python
Plugin 'davidhalter/jedi-vim'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'fisadev/vim-isort'

" LaTeX
Plugin 'lervag/vimtex'

" Easymotion
Plugin 'easymotion/vim-easymotion'
" csv
Plugin 'chrisbra/csv.vim'

" Alloy
" Plugin 'runoshun/vim-alloy'
"
" Coq
"Plugin 'let-def/vimbufsync'
"Plugin 'the-lambda-church/coquille'

call vundle#end()

syntax on                      " syntax hilighting
filetype plugin indent on      " enable filetype detection
behave xterm                   " do not use this stupid select mode

"
" set
"

set autoindent
set autochdir
set autoread
set backspace=indent,eol,start  " backspace through everything in insert mode
set backupdir=~/.tmp,.
set cinoptions=(0,t0,g0,:0,w1,W4
set clipboard=exclude:.*
set colorcolumn=81
set complete+=t
set completeopt=menu,longest
set cursorline                 " highlight current line
set dictionary+=/usr/share/dict/words
set diffopt+=vertical
set directory=~/.tmp,.,/tmp
set display=lastline           " open the file where we last closed it
set expandtab                  " replace tab by the appropriate nb of spaces
set fileformat=unix
set grepprg=grep\ -nH\ $*      " necessary for latex
set guioptions=a               " no menus, no icons
set hidden                     " ability to switch buffer without saving
set history=50
set hlsearch                   " highlight search result
set lazyredraw
set ignorecase                 " case insensitive searce
set incsearch                  " show the next search pattern as you type
set laststatus=2               " always show the status bar
set linespace=1                " set the space between two lines (gui only)
set list                       " we do what to show tabs, to ensure we get them
                               " out of my files
set listchars=nbsp:¤,tab:▸-,trail:-,eol:¬,extends:❯,precedes:❮ " show tabs and trailing
set magic                      " use regexp in search
set matchtime=5                " how many tenths of a second to blink
                               " matching brackets for
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
set splitright
set suffixes+=.aux,.bak,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.info,.inx,.log
set suffixes+=.o,.obj,.out,.swp,.toc,~
set tabstop=4                  " what is a tab?
set tags=tags;/                " upward search, up to the root directory
set textwidth=80               " no more than 80 char per line
set viminfo='20,\"50
" allow moving cursor past end of line in visual block mode
set virtualedit+=block
set whichwrap=<,>,[,],h,l
set wildmode=list:full         " show list and try to complete
set wildignorecase

"
" iabbrev
"

iabbrev #d #define
iabbrev \i \item

" Better to put it around the top
let g:mapleader               = ','
let g:maplocalleader          = ','
let g:mapleader               = ','

"
" map
"

" Realign paragraph
map & gqap

" Calling accidentally help is so annoying!!
map <F1> <Esc>
imap <F1> <Esc>

nmap <F2> :TagbarToggle<CR>
nmap <F3> :NERDTreeToggle<CR>
nmap <F5> :exec '!'.getline('.')<CR>

map <F4> :Isort<CR>
nmap <F4> :Isort<CR>

nmap <C-P> :Files<CR>
nmap <C-B> :Buffers<CR>
nmap <C-G> :GFiles?<CR>
imap <C-x><C-l> <plug>(fzf-complete-line)

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

nmap <Leader>d :DiffSaved<CR>

nmap <Leader>h :nohl<CR>

nmap <Leader>n :Nl<CR>
nmap <Leader>N :RNl<CR>

nmap <Leader>o :call OldPunc()<CR>

nmap <Leader>u :Utl<CR>

nmap <Leader>l :resize 60<CR>
nmap <Leader>r :vertical resize 83<CR>

nmap <Leader>s :source $MYVIMRC<CR>
nmap <Leader>v :edit $MYVIMRC<CR>

nmap <Leader>= :Black<CR>

if has('unix')
    nmap <Leader>1 :winsize 83 55<CR>
    nmap <Leader>2 :winsize 123 55<CR>
    nmap <Leader>3 :winsize 163 55<CR>
elseif has('win32')
    nmap <Leader>1 :winsize 83 55<CR>
    nmap <Leader>2 :winsize 123 55<CR>
    nmap <Leader>3 :winsize 163 55<CR>
endif

nnoremap <Leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" select until last position
nnoremap <Leader>V V`]

" sort css
" nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" open nerdtree if no file specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" close vim if nerd is last open buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Place next match in the middle of the scren
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $
nnoremap gV `[v`]

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

" sudo trick
cmap w!! w ! sudo tee > /dev/null %

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Highlight characters over column 85
" match MoreMsg /\(.\+\s\+$\|\%>85v.\+\)/

syntax match DoubleSpace /  \+/
highlight link DoubleSpace MoreMsg

" au BufEnter *.md match MoreMsg '\(porcupine\)'
" au BufLeave *.md match MoreMsg /\(.\+\s\+$\|\%>85v.\+\)/

" theme

colorscheme seoul256

if has("gui_running")
    let g:seoul256_background = 234
    let g:airline_theme='lessnoise'
else
    let g:airline_theme='lessnoise'
endif

"
" function
"
"  TIP #1030
function! s:DiffWithSaved()
    let l:filetype=&filetype
    diffthis
    vnew | r # | normal 1Gdd
    diffthis
    exe 'setlocal bt=nofile bh=wipe nobl noswf ro ft=' . l:filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" Tabularize related
function! s:align()
  let l:p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# l:p || getline(line('.')+1) =~# l:p)
    let l:column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let l:position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|', l:column).'\s\{-\}'.repeat('.', l:position),'ce',line('.'))
  endif
endfunction

function! OldPunc()
    %call setline('.', tr(getline('.'),'’“”',"'\"\""))
endfunction

"
" command, autocommand
"

command! Nl if (&nu) <Bar> set nonu <Bar> else <Bar> set nu <Bar> endif
command! RNl if (&rnu) <Bar> set nornu <Bar> else <Bar> set rnu <Bar> endif

" Jump to last position in the file, see <url:vimhelp:last-position-jump>
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \ | exe "normal g`\"" | endif


autocmd BufEnter SCons*,*.scons  set filetype=scons
autocmd BufEnter *.i             set filetype=cpp

autocmd BufEnter *.g4            set filetype=antlr
autocmd BufEnter *.smt2,*.smt    set filetype=smt2

autocmd InsertLeave *            set nocursorline
autocmd InsertEnter *            set cursorline

autocmd FileType clojure,c,cpp,ruby,cmake,smt2 setl shiftwidth=2 tabstop=2
autocmd FileType r,cmake                       setl comments+=b:#'
autocmd FileType java                          setl cindent

autocmd Syntax gitcommit         setl textwidth=72

autocmd BufWinEnter,BufNewFile * silent tabo           " I hate tabs!

autocmd BufRead,BufNewFile,BufEnter * cd %:p:h

autocmd BufWritePre *.py execute ':Black'

"
" let
"

let g:utl_cfg_hdl_mt_generic='silent !xdg-open "%p" &'
let g:utl_cfg_hdl_scm_http_system = 'silent !xdg-open "%u" &'

"silent !firefox -remote 'ping()' && firefox -remote 'openURL( %u )' || firefox '%u' &"

let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#virtualenv#enabled = 1

" let g:EnhCommentifyFirstLineMode   = "yes"
" let g:EnhCommentifyPretty          = "yes"
" let g:EnhCommentifyTraditionalMode = "no"
" let g:EnhCommentifyUseSyntax       = "yes"

let g:tex_flavor                   = 'latex'
let g:Tex_DefaultTargetFormat      = 'pdf'

" let g:syntastic_cpp_config_file    = '.clang_complete'
" let g:syntastic_tex_checkers       = ['chktex']  " lacheck = big pile of shit
" Warning 1: Command terminated with space
" Warning 6: No italic correction (`\/') found
" Warning 8: Wrong length of dash
" Warning 11: ... should be \ldots
"
" let g:syntastic_tex_chktex_args    = "-n1 -n6 -n8 -n11"
" let g:syntastic_ocaml_checkers     = ['merlin']

let g:ale_linters = {
\ 'python': ['flake8', 'mypy'],
\ 'latex': ['chktex'],
\ }

let g:ale_fixers = {
\ 'python': ['isort', 'black'],
\ 'markdown': ['prettier'],
\ }

let g:black_linelength = 80

let g:ale_python_auto_poetry = 1

let g:ale_python_mypy_options = '--strict-optional --ignore-missing-imports'
let g:ale_sign_error='E'  " \uf05e
let g:ale_sign_warning='W'  " \uf071

let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'
let g:airline#extensions#ale#show_line_numbers = 1
let g:airline#extensions#ale#open_lnum_symbol = '(L'
let g:airline#extensions#ale#close_lnum_symbol = ')'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.colnr = ' :'
let g:airline_symbols.linenr = ' ㏑ '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''

let g:clang_snippets               = 0
let g:clang_snippets_engine        = ''

if has('mac')
    let g:Tex_ViewRule_pdf    = 'Preview'
    let g:Tex_CompileRule_pdf = 'xelatex'
elseif has('unix')
    let g:Tex_CompileRule_pdf = 'xelatex'
elseif has('win32')
    let g:tagbar_ctags_bin      = 'ctags'
endif

if has('gui_running')
    set lines=55
    if has('mac')
        set guifont=Fira Code:h11
        set macligatures
    elseif has('unix')
        set guifont=Fira\ Mono\ for\ Powerline\ 11
        set lines=55
    elseif has('win32')
        set guifont=Consolas\ for\ Powerline\ FixedD:h11:cDEFAULT
        set lines=55
    endif
endif
