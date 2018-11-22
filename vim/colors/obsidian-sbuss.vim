"these lines are suggested to be at the top of every colorscheme
hi clear
if exists("syntax_on")
  syntax reset
endif

"Load the 'base' colorscheme - the one you want to alter
runtime colors/obsidian.vim

"Override the name of the base colorscheme with the name of this custom one
let colors_name = "obsidian-sbuss"

" Darken the background color, lighten foreground
hi clear Normal
hi Normal           guifg=#D4D2CF           guibg=#131313
hi Normal           ctermfg=254             ctermbg=NONE

" Darken the left-hand number column
hi clear NonText
hi NonText          guifg=#404040                                   gui=none
hi NonText          ctermfg=234                                     cterm=none

" Lighten comments
"hi Comment          guifg=#787775                                  gui=italic
hi Comment          ctermfg=248                                     cterm=none
