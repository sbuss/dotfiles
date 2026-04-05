set nocompatible

syn on
set shiftwidth=4
set noexpandtab
set autoindent

autocmd FileType markdown setlocal expandtab softtabstop=4 tabstop=8
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType python setlocal expandtab softtabstop=4 tabstop=8
autocmd FileType ruby setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
autocmd FileType html setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=8
autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
autocmd FileType coffee setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
autocmd FileType htmldjango setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=8
autocmd FileType sh setlocal tabstop=8 expandtab
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4

set showmatch
set number
set foldmethod=indent

source $HOME/.vim/plugins

" Explicitly support 256 colors
set t_Co=256
set background=dark
let g:solarized_contrast="high"
colorscheme solarized

" wrap long lines and display them
setlocal wrap linebreak nolist
set virtualedit=
setlocal display+=lastline

noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj

" Moving around long lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

map <A-j> yyP
highlight Comment term=NONE ctermfg=Cyan

" Highlight things longer than 100 characters
set ruler
:match ErrorMsg '\%>100v.\+'
:set cc=78

" wildmenu shows menu suggestions
set wildmenu
set wildmode=longest:full
set completeopt+=longest
set wildignore+=*.pyc,*.git,*.o,*.class
set wildignorecase

" Store *.swp files in ~/.vim/swap
set directory=$HOME/.vim/swap//

" persistent undo
set undofile
set undodir=$HOME/.vim/undo//

" Arpeggio
call arpeggio#load()
" I'm too slow to hit j & f together, so lengthen the timeout on them
let g:arpeggio_timeoutlens = {'j':100, 'f':100}
Arpeggio inoremap jk <Esc>
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

set laststatus=2

" Use the system clipboard
"set clipboard=unnamedplus

" OSX brew-installed vim... breaks backspace? This fixes it.
set backspace=2
