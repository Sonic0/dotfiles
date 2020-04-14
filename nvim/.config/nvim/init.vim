" Import plugins
source ~/.config/nvim/plugins.vim

" Many basic options are already set by the tpope/vim-sensible plugin


" ================ Theme/Color Config ====================

" Set color scheme
colorscheme iceberg
"""" Color scheme from Tobi
""""colorscheme quantum
set guifont=DroidSansMono\ Nerd\ Font\ 11
set fillchars+=vert:\$
set background=dark

" Set true terminal colors
set termguicolors


" ================ General Config ====================

" 'hidden' allow Vim to manage multiple buffers effectively.
" 1)The current buffer can be put to the background without writing to disk;
" 2)When a background buffer becomes current again, marks and undo-history are remembered.
set hidden
" No sounds
"set visualbell
" Show the (partial) command as it is being typed
set showcmd
" Give more space for displaying messages.
set cmdheight=2
" Change mapleader
" Disable Vim welcome message
set shortmess=I
" Use system clipboard
set clipboard=unnamedplus
" Set leader key
let mapleader=","
" Enable relative line numbers
set relativenumber
set number
" Highlight searches
set hlsearch
" These two options, when set together, will make /-style searches case-sensitive only if there is a capital letter in the search expression. 
" *-style searches continue to be consistently case-sensitive. 
" Ignore case of searches
set ignorecase
" Use smart case for searching
set smartcase
" Do not reset cursor to start of line when moving around
set nostartofline
" More natural splitting of windows
set splitbelow
set splitright
" Soft wrapping of lines
set wrap linebreak
" Set spell check language to US English
set spelllang=en_us
" Shows a $ sign at the end of each line and shows ^I instead of tabs
set list
" Enables the mouse in all modes.  This means copying will require holding shift.
set mouse=a
" Search whole project
nnoremap \ :Rg<space>


" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Indentation ======================

" based options setted by vim-sensible


" ================ Mapping keys ======================

" add the date and time at the press of F3
nmap <F3> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
imap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>

" ================ Functions ======================

" convert rows of numbers or text (as if pasted from excel column) to a tuple
function! ToTupleFunction() range
    silent execute a:firstline . “,” . a:lastline . “s/^/’/”
    silent execute a:firstline . “,” . a:lastline . “s/$/’,/”
    silent execute a:firstline . “,” . a:lastline . “join”
    silent execute “normal I(“
    silent execute “normal $xa)”
"    silent execute “normal ggVGYY” "copy to clipboard, requires -> vnoremap YY "*y
endfunction
command! -range ToTuple <line1>,<line2> call ToTupleFunction()

" convert rows of numbers or text (as if pasted from excel column) to an array
function! ToArrayFunction() range
    silent execute a:firstline . "," . a:lastline . "s/^/’/"
    silent execute a:firstline . "," . a:lastline . "s/$/’,/"
    silent execute a:firstline . "," . a:lastline . "join"
    " these two lines below are different by only one character!
    silent execute "normal I["
    silent execute "normal $xa]"
endfunction
command! -range ToArray <line1>,<line2> call ToArrayFunction()

" ================ Others ======================

" Preview for find-replace command
set inccommand=split

" Strip trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e
" Unify indentation on save
autocmd BufWritePre * retab
" Enable spell checking for certain file types
autocmd BufRead,BufNewFile *.md,*.tex setlocal spell

" Shortcut to search whole project
nnoremap \ :Rg<space>
