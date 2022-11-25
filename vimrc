"-------------------------------PLUGIN_MANAGER---------------------------------

"Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()
" install pathogen plugin manager if version <8

"------------------------------------------------------------------------------

"Basic
filetype indent plugin on       " turn on filetype based indenting and syntax highlighting
syntax on
:set wildmenu                   " auto complete in command-line mode
:set wildmode=longest:full,full

:set noswapfile
" :set wrap
" :set linebreak

:set background=dark
:set t_Co=256

"UI
:set number                     " view line numbers
:set norelativenumber
:set showcmd                    " show commands in bottom right corner
:set ruler                      " show line/column information in bottom right corner
:set colorcolumn=80             " draw red line vertically at desired column
" :set textwidth=80              " go to next line after crossing desired number of characters
:set cursorline                 " highlight current line
:set cursorcolumn               " highlight current column
:highlight CursorColumn ctermbg=Brown
:set showmatch                  " highlight matching ({})
:set listchars=tab:▸\ ,eol:¬    " make tabs and eol readable

"Spaces and Tab
:set tabstop=4                  " number of visual spaces per tab
:set softtabstop=4              " number of spaces inserted per tab while editing
:set expandtab                  " replace tabs with spaces
:set shiftwidth=2               " number of spaces to use for each step of indent (>>)

"Folding
:set foldenable                 " enable folding
:set foldmethod=syntax

"Search
:set incsearch                  " search as you type out
:set hlsearch                   " highlight search

"Splits
:nnoremap <C-J> <C-W><C-J>
:nnoremap <C-K> <C-W><C-K>
:nnoremap <C-L> <C-W><C-L>
:nnoremap <C-H> <C-W><C-H>
                                " navigation
:set splitbelow                 " natural splitting
:set splitright

"$MYVIMRC edits
:let mapleader = "\<Space>"     "map <leader>, map edit and source $MYVIMRC
:nnoremap <leader>ev :split $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>

"-------------------------------EDITING----------------------------------------

"delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d
"replace currently selected text with default register without yanking it
vnoremap <leader>p "_dP

"-------------------------------PLUGINS----------------------------------------

"Git repo should contain these plugins:
"*vim-pathogen
"*vim-commentary
"*vim-surround
"*vim-autoformat
"*ctrlP
"*Tagbar

"commentary
:autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
:noremap <leader>/ :Commentary<cr>
"change comment style to // inplace of /* */

"CtrlP
:nnoremap <leader>. :CtrlPTag<cr>
:let g:ctrlp_open_multiple_files = '1r'
" let g:ctrlp_max_files=0
" let g:ctrlp_max_depth=12

"Tagbar
nnoremap <silent> <leader>b :TagbarToggle<CR>

"ctags
" command! Gentags execute '!git ls-files | grep -E "\.(cpp|hpp|proto)$" | ctags -–extra=+q -L -'
command! Gentags execute '!git ls-files | grep -E "\.(hpp|cpp|proto)$" | ctags --c++-kinds=+p --extra=+q -L -'
":Gentags to create tags

"Clang
" map <leader>k :py3f ~/thoughtspot/git_scripts/clang-format.py<CR>
" map <leader>k :pyf ~/thoughtspot/git_scripts/clang-format.py<CR>
map <leader>k :pyf ~/clang-format.py<CR>

"Autoformat
noremap <leader>p :Autoformat<CR>
"------------------------------EXPERIMENTS-------------------------------------
