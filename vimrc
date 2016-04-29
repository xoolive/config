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

" Look and feel
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'altercation/vim-colors-solarized'

" CSV-like alignment
Bundle 'godlygeek/tabular.git'

" Parse through files/directories/buffers
Bundle 'kien/ctrlp.vim.git'

" Support for ack
Bundle 'mileszs/ack.vim.git'

" Add the tagbar (need for exuberant-ctags)
Bundle 'majutsushi/tagbar.git'

" Syntax checker
Bundle 'scrooloose/syntastic.git'

" Access to Remove, Rename, Mkdir, etc.
Bundle 'tpope/vim-eunuch.git'

" Add support to s in csb[, etc.
Bundle 'tpope/vim-surround.git'
" I need to repeat those!
Bundle 'tpope/vim-repeat.git'

" Working with git
Bundle 'tpope/vim-fugitive.git'
Bundle 'airblade/vim-gitgutter'

" URL
Bundle 'vim-scripts/utl.vim.git'

" Fun for use with man
" Add the following to your .zshrc
" function vman {
"     vim -c "SuperMan $*"
"     if [ "$?" != "0" ]; then
"       echo "No manual entry for $*"
"     fi
" }
Bundle 'jez/vim-superman'

" Convenient for C/C++
Bundle 'vim-scripts/a.vim'
Bundle 'Rip-Rip/clang_complete.git'

" Working with Python
Bundle 'davidhalter/jedi-vim'

" Working with Clojure
Bundle 'vim-scripts/VimClojure.git'

" Working with Scala
Bundle 'derekwyatt/vim-scala'

" Working with R
Bundle 'vim-scripts/Conque-Shell.git'
Bundle 'jcfaria/Vim-R-plugin.git'

" Working with coq
" Bundle 'jvoorhis/coq.vim'
" Bundle 'xoolive/CoqIDE'

" Working with Markdown/Pandoc
Bundle 'vim-pandoc/vim-pandoc'
Bundle 'vim-pandoc/vim-pandoc-syntax'
Bundle 'reedes/vim-pencil'

" For snippets
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'

" Distraction-free writing
Bundle 'junegunn/goyo.vim'

if has("mac")
    Bundle 'http://git.code.sf.net/p/vim-latex/vim-latex'
else
    Bundle 'xoolive/vim-latex'
endif

syntax on                      " syntax hilighting
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on      " enable filetype detection
behave xterm                   " do not use this stupid select mode

let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
let $PATH .= ':' . substitute(system('opam config var bin'),'\n$','','''')

execute "set rtp+=" . g:opamshare . "/ocp-indent/vim"

execute "set rtp+=" . g:opamshare . "/merlin/vim"
execute "helptags " . g:opamshare . "/merlin/vim/doc"

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
set diffopt+=vertical
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
set listchars=nbsp:¤,tab:▸-,trail:-,eol:¬,extends:❯,precedes:❮ " show tabs and trailing
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
" allow moving cursor past end of line in visual block mode
set virtualedit+=block
set whichwrap=<,>,[,],h,l
set wildmode=list:full         " show list and try to complete

"
" iabbrev
"

" iabbrev #i <C-R>=SmartInclude()<CR>
iabbrev #d #define
iabbrev \i \item


" Better to put it around the top
let mapleader                 = ','
let maplocalleader            = ','
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
nmap <F5> :exec '!'.getline('.')<CR>

nmap <C-B> :CtrlPBuffer<CR>
nmap <C-H> :CtrlPMRUFiles<CR>

nmap <Leader>d :DiffSaved<CR>
nmap <Leader>D :DiffSVN<CR>

nmap <Leader>e :Errors<CR>
nmap <Leader>h :nohl<CR>

nmap <Leader>n :Nl<CR>
nmap <Leader>N :RNl<CR>

nmap <Leader>o :call OldPunc()<CR>

nmap <Leader>u :Utl<CR>

nmap <Leader>l :resize 60<CR>
nmap <Leader>r :vertical resize 83<CR>

nmap <Leader>s :source $MYVIMRC<CR>
nmap <Leader>v :edit $MYVIMRC<CR>

if has("unix")
    nmap <Leader>1 :winsize 83 50<CR>
    nmap <Leader>2 :winsize 123 50<CR>
    nmap <Leader>3 :winsize 163 50<CR>
elseif has("win32")
    nmap <Leader>1 :winsize 83 55<CR>
    nmap <Leader>2 :winsize 123 55<CR>
    nmap <Leader>3 :winsize 163 55<CR>
endif

" Follow links with Superman!
noremap K :SuperMan <cword><CR>

" remove trailing spaces
nnoremap <Leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" select until last position
nnoremap <Leader>V V`]

" sort css
" nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" Place next match in the middle of the scren
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap n nzzzv
nnoremap N Nzzzv

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

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" Highlight characters over column 85
match MoreMsg /\(.\+\s\+$\|\%>85v.\+\)/

syntax match DoubleSpace /  \+/
highlight link DoubleSpace MoreMsg

au BufEnter *.md match MoreMsg '\(porcupine\)'
au BufLeave *.md match MoreMsg /\(.\+\s\+$\|\%>85v.\+\)/

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

function! OldPunc()
    %call setline(".", tr(getline("."),"’“”","'\"\""))
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

autocmd BufEnter *.ela           set filetype=pamela
autocmd BufEnter *.ele,*.els     set filetype=electrum
autocmd BufEnter *.gamme         set filetype=gamme
autocmd BufEnter *.smt2,*.smt    set filetype=smt2

autocmd InsertLeave *            set nocursorline
autocmd InsertEnter *            set cursorline

autocmd FileType clojure,c,cpp,ruby,cmake   setl shiftwidth=2 tabstop=2
autocmd FileType pamela,electrum,gamme,smt2 setl shiftwidth=2 tabstop=2
autocmd FileType r,cmake                    setl comments+=b:#'
autocmd FileType java                       setl cindent

autocmd Syntax gitcommit         setl textwidth=72

autocmd BufWinEnter,BufNewFile * silent tabo           " I hate tabs!

"
" let
"

let g:airline#extensions#hunks#non_zero_only = 1

let g:vimrplugin_conqueplugin      = 1
let g:vimrplugin_conquevsplit      = 0

let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow      = 1

" let g:CoqIDEDefaultMap             = 1

let g:EnhCommentifyFirstLineMode   = "yes"
let g:EnhCommentifyPretty          = "yes"
let g:EnhCommentifyTraditionalMode = "no"
let g:EnhCommentifyUseSyntax       = "yes"

let g:pandoc#filetypes#handled         = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#modules#disabled          = ["folding"]

let g:tex_flavor                   = 'latex'
let g:Tex_DefaultTargetFormat      = 'pdf'

let g:syntastic_cpp_config_file    = '.clang_complete'
let g:syntastic_tex_checkers       = ['chktex']  " lacheck = big pile of shit
" Warning 1: Command terminated with space
" Warning 6: No italic correction (`\/') found
" Warning 8: Wrong length of dash
" Warning 11: ... should be \ldots
let g:syntastic_tex_chktex_args    = "-n1 -n6 -n8 -n11"

let g:syntastic_ocaml_checkers     = ['merlin']

let g:airline_powerline_fonts = 1
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols = {}
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = ''
let g:gitgutter_sign_removed = '✗'

let g:syntastic_error_symbol=' '
let g:syntastic_style_error_symbol=' '
let g:syntastic_warning_symbol=' '
let g:syntastic_style_warning_symbol=' '

let g:clang_snippets               = 0
let g:clang_snippets_engine        = ''

if has("mac")
    let g:libclang_path = system('mdfind -name libclang.dylib')
    let g:clang_library_path = substitute(libclang_path,'\n$','','''')
elseif has("unix")
    let g:clang_library_path = '/usr/lib/llvm-3.6/lib'
endif

if has("mac")

    let g:ackprg              = "ack -H --nocolor --nogroup --column"
    let g:Tex_ViewRule_pdf    = 'Preview'
    let g:Tex_CompileRule_pdf = 'xelatex'

elseif has("unix")

    let g:ackprg              = "ack-grep -H --nocolor --nogroup --column"
    let g:Tex_CompileRule_pdf = 'xelatex'

elseif has("win32")

    let g:ackprg              = "ack.bat -H --nocolor --nogroup --column"
    let tagbar_ctags_bin      = 'ctags'

endif

if has("gui_running")

    colorscheme molokai
    let g:airline_theme='powerlineish'

    if has("mac")
        set gfn=Menlo:h12
        set gfn=Menlo\ for\ Powerline:h12
        " https://github.com/ryanoasis/nerd-fonts
        set gfn=Literation\ Mono\ Powerline\ Nerd\ Font\ Plus\ Octicons:h12
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

else
    colorscheme koehler
    let g:airline_theme="lucius"

endif
