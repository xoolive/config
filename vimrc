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
"    Conque-Shell   https://github.com/vim-scripts/Conque-Shell.git
"    Vim-R-plugin   https://github.com/jcfaria/Vim-R-plugin.git
"    ack.vim        https://github.com/mileszs/ack.vim.git
"    badwolf        https://github.com/sjl/badwolf.git
"    clang-complete https://github.com/Rip-Rip/clang_complete.git
"    ctrlp.vim      https://github.com/kien/ctrlp.vim.git
"    jedi-vim       https://github.com/davidhalter/jedi-vim
"    omlet.vim      https://github.com/vim-scripts/omlet.vim.git
"    syntastic      https://github.com/scrooloose/syntastic.git
"    tabular        https://github.com/godlygeek/tabular.git
"    tagbar         https://github.com/majutsushi/tagbar.git
"    utl.vim        https://github.com/vim-scripts/utl.vim.git
"    vim-eunuch     https://github.com/tpope/vim-eunuch.git
"    vim-fugitive   https://github.com/tpope/vim-fugitive.git
"    vim-latex      git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex
"    vim-powerline  https://github.com/Lokaltog/vim-powerline.git
"    vim-surrond    https://github.com/tpope/vim-surround.git


if has("win32")
    let $VIMFILES=expand("D:\xolive\Documents\github\config\vim")
end


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
set nostartofline              " do not move to the first char of line
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

if has("mac")
    nmap <Leader>1 :winsize 81 50<CR>
    nmap <Leader>2 :winsize 121 50<CR>
    nmap <Leader>3 :winsize 161 50<CR>
elseif has("unix")
    nmap <Leader>1 :winsize 81 45<CR>
    nmap <Leader>2 :winsize 121 45<CR>
    nmap <Leader>3 :winsize 161 45<CR>
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
autocmd BufEnter *.i             setf cpp
autocmd BufEnter *.java          set  cindent
autocmd BufEnter CMakeLists.txt  set  comments+=b:#' shiftwidth=2 tabstop=2
autocmd BufWinEnter,BufNewFile * silent tabo           " I hate tabs!
autocmd Syntax cpp               call EnhanceSyntax()
autocmd Syntax ocaml             set shiftwidth=2 tabstop=2

"
" let
"

let g:vimrplugin_conqueplugin      = 1
let g:vimrplugin_conquevsplit      = 0

let g:EnhCommentifyFirstLineMode   = "yes"
let g:EnhCommentifyPretty          = "yes"
let g:EnhCommentifyTraditionalMode = "no"
let g:EnhCommentifyUseSyntax       = "yes"

let g:tex_flavor                   = 'latex'
let g:Tex_DefaultTargetFormat      = 'pdf'

let g:syntastic_error_symbol       = '✗'
let g:syntastic_warning_symbol     = '⚠'
let g:syntastic_cpp_config_file    = '.clang_complete'
let loaded_tex_syntax_checker      = 0 " stop lacheck, this is just lame!


let g:clang_snippets               = 0
let g:clang_snippets_engine        = ''

let omlet_indent_let               = 0

if has("mac")

    let g:ackprg              = "ack -H --nocolor --nogroup --column"
    let g:Tex_ViewRule_pdf    = 'Preview'
    let g:Tex_CompileRule_pdf = 'xelatex'

elseif has("unix")

    let g:ackprg              = "ack-grep -H --nocolor --nogroup --column"

elseif has("win32")

    let g:ackprg = "D:\\xolive\\Documents\\apps\\ack.bat -H --nocolor --nogroup --column"
    let tagbar_ctags_bin = 'D:\xolive\Documents\apps\ctags58\ctags'

endif


if has("gui_running")

    colorscheme molokai

    if has("mac")
        set gfn=Menlo:h12
"         set gfn=Source\ Code\ Pro\ Light:h13
        set gfn=Menlo\ for\ Powerline:h12
        let g:Powerline_symbols = 'fancy'
        set lines=50
    elseif has("unix")
        set gfn=Monospace\ 11
        set gfn=DejaVuSans\ Mono\ for\ Powerline\ 11
        let g:Powerline_symbols = 'fancy'
        set lines=45
"         vertical resize 81
    elseif has("win32")
        set gfn=Lucida_Console:h10:cANSI
        set gfn=Menlo\ for\ Powerline:h11:cDEFAULT
        set gfn=Consolas\ for\ Powerline\ FixedD:h11:cDEFAULT
"         set gfn=Source\ Code\ Pro\ Light:h11:cDEFAULT
        let g:Powerline_symbols = 'fancy'
        set lines=55
    endif
endif

