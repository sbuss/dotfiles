syn on
set tabstop=8
set shiftwidth=4
set expandtab
set softtabstop=4
set autoindent

set showmatch

set number

" Vundle
set nocompatible 
filetype off                  " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let vundle manage vundle
Bundle 'gmarik/vundle'

" My bundles here
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'nvie/vim-flake8'
Bundle 'garbas/vim-web-indent'
Bundle 'kana/vim-arpeggio'
Bundle 'ervandew/supertab'
Bundle 'sontek/rope-vim'

filetype plugin indent on     " required! 
 "
 " Brief help
 " :BundleList          - list configured bundles
 " :BundleInstall(!)    - install(update) bundles
 " :BundleSearch(!) foo - search(or refresh cache first) for foo
 " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
 "
 " see :h vundle for more details or wiki for FAQ
 " NOTE: comments after Bundle command are not allowed..

"set wrap
"set linebreak
"set nolist
"set virtualedit=
"set display += lastline


colorscheme slate 

nmap <silent><Home> :call SmartHome("n")<CR>
nmap <silent><End> :call SmartEnd("n")<CR>
imap <silent><Home> <C-r>=SmartHome("i")<CR>
imap <silent><End> <C-r>=SmartEnd("i")<CR>
vmap <silent><Home> <Esc>:call SmartHome("v")<CR>
vmap <silent><End> <Esc>:call SmartEnd("v")<CR>

function SmartHome(mode)
  let curcol = col(".")
  "gravitate towards beginning for wrapped lines
  if curcol > indent(".") + 2
    call cursor(0, curcol - 1)
  endif
  if curcol == 1 || curcol > indent(".") + 1
    if &wrap
      normal g^
    else
      normal ^
    endif
  else
    if &wrap
      normal g0
    else
      normal 0
    endif
  endif
  if a:mode == "v"
    normal msgv`s
  endif
  return ""
endfunction

function SmartEnd(mode)
  let curcol = col(".")
  let lastcol = a:mode == "i" ? col("$") : col("$") - 1
  "gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif
  if curcol < lastcol
    if &wrap
      normal g$
    else
      normal $
    endif
  else
    normal g_
  endif
  "correct edit mode cursor position, put after current character
  if a:mode == "i"
    call cursor(0, col(".") + 1)
  endif
  if a:mode == "v"
    normal msgv`s
  endif
  return ""
endfunction


"wrap long lines and display them, even if they're longer than the 
"available space on the screen
setlocal wrap linebreak nolist
set virtualedit=
setlocal display+=lastline

noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj

map <A-j> yyP
highlight Comment term=NONE ctermfg=Cyan

" Highlight things longer than 74 characters
set ruler
:match ErrorMsg '\%>74v.\+'

" Always open nerdtree at the proj bookmark
"autocmd vimenter * NERDTree proj

" Close vim if the only open window is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Auto-run flake8 on every write of a .py file
" flake8 runs pyflakes, pep8, and complexity checkers
autocmd BufWritePost *.py call Flake8()

" wildmenu shows menu suggestions
set wildmenu

" Store *.swp files in ~/.vim/swap. The // is to escape full file paths
set directory=$HOME/.vim/swap//

" supertab
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" Arpeggio 
call arpeggio#load()
Arpeggio inoremap jk <Esc>
Arpeggio noremap jkl :NERDTreeToggle
Arpeggio noremap jf :w
" git status
Arpeggio noremap gs :Gstatus 

" persistent undo
set undofile
set undodir=$HOME/.vim/undo//

let g:statline_syntastic = 0
" see :h fugitive-statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
"set statusline+=%{SyntasticStatuslineFlag()}
set laststatus=2 " always show the status line
