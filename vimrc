syn on
set shiftwidth=4
set noexpandtab
set autoindent
set guifont=Droid\ Sans\ Mono:h12

autocmd FileType markdown setlocal expandtab softtabstop=4 tabstop=8
autocmd FileType python setlocal expandtab softtabstop=4 tabstop=8
autocmd FileType ruby setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
autocmd FileType html setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=8
autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
autocmd FileType coffee setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
autocmd FileType htmldjango setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=8
autocmd FileType sh setlocal tabstop=8 expandtab

set showmatch

set number

" Code folding
set foldmethod=indent

" Vundle
set nocompatible 
filetype off                  " required!
set rtp+=~/.vim/bundle/Vundle.vim
"set rtp+=$GOROOT/misc/vim
call vundle#begin()

" Let vundle manage vundle
Plugin 'gmarik/vundle'

" My bundles here
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdtree'
Plugin 'nvie/vim-flake8'
Plugin 'garbas/vim-web-indent'
Plugin 'vim-scripts/django.vim'
Plugin 'kana/vim-arpeggio'
Plugin 'ervandew/supertab'
Plugin 'jnwhiteh/vim-golang'
Plugin 'kchmck/vim-coffee-script'
Plugin 'godlygeek/tabular'

" Puppet
Plugin 'rodjek/vim-puppet'

" clojure bundles
Plugin 'tpope/vim-fireplace'
Plugin 'guns/vim-clojure-static'
Plugin 'amdt/vim-niji'
Plugin 'paredit.vim'

call vundle#end()             " required!
filetype plugin indent on     " required! 
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

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

" Look for the tags file in a few directories up LOL
set tags=./tags,../tags,../../tags,../../../tags,../../../../tags

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
" This doesn't always work
"set ruler
":match ErrorMsg '\%>74v.\+'
:set cc=78

" Always open nerdtree at the proj bookmark
"autocmd vimenter * NERDTree proj

" Close vim if the only open window is NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Auto-run flake8 on every write of a .py file
" flake8 runs pyflakes, pep8, and complexity checkers
autocmd BufWritePost *.py call Flake8()

" wildmenu shows menu suggestions
set wildmenu
set wildmode=longest:full
set completeopt+=longest
set wildignore+=*.pyc,*.git,*.o,*.class
set wildignorecase

" Store *.swp files in ~/.vim/swap. The // is to escape full file paths
set directory=$HOME/.vim/swap//

au BufRead,BufNewFile *.go set filetype=go
" supertab
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" Arpeggio 
call arpeggio#load()
" I'm too slow to hit j & f together, so lengthen the timeout on them
let g:arpeggio_timeoutlens = {'j':100, 'f':100}
Arpeggio inoremap jk <Esc>
Arpeggio noremap jkl :NERDTreeToggle<CR>
Arpeggio noremap jf :w<CR>
Arpeggio noremap ls :ls<CR>
" Buffer movement
Arpeggio noremap wq <C-w>q
Arpeggio noremap wj <C-w>j
Arpeggio noremap wk <C-w>k
Arpeggio noremap wh <C-w>h
Arpeggio noremap wl <C-w>l
Arpeggio noremap ws <C-w>s
Arpeggio noremap wv <C-w>v
" fast up & down
Arpeggio noremap fd 10j
Arpeggio noremap fu 10k
" git status
Arpeggio noremap gs :Gstatus<CR>
Arpeggio noremap gb :Gblame<CR>
" ropevim code lookup
Arpeggio noremap pj :RopeGotoDefinition<CR>
Arpeggio noremap pr :RopeRename<CR>

" persistent undo
set undofile
set undodir=$HOME/.vim/undo//

let g:statline_syntastic = 1
" see :h fugitive-statusline
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
"set statusline+=%{SyntasticStatuslineFlag()}
set laststatus=2 " always show the status line

" Go plugins
set rtp+=$GOROOT/misc/vim
"filetype plugin indent on  " Already set above
syntax on
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4
Arpeggio noremap gd :Godoc<CR>
Arpeggio noremap gf :Fmt<CR>

function! Marked()
    execute 'set filetype=markdown'
    execute '!open -a Marked '.expand('%')
endfunction

Arpeggio noremap md :call Marked()<CR><CR>

" Moving around long lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
