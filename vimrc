"-------------------------------PLUGIN_MANAGER---------------------------------

"Pathogen
execute pathogen#infect()
" install pathogen plugin manager if version <8

"------------------------------------------------------------------------------

"Basic
filetype indent plugin on       " turn on filetype based indenting and syntax highlighting
syntax on
:set wildmenu                   " auto complete in command-line mode
:set wildmode=longest:full,full

"UI
:set number                     " view line numbers
:set relativenumber
:set showcmd                    " show commands in bottom right corner
:set ruler                      " show line/column information in bottom right corner
:set colorcolumn=80             " draw red line vertically at desired column
:set textwidth=80               " go to next line after crossing desired number of characters
:set cursorline                 " highlight current line
:set cursorcolumn               " highlight current column
:set showmatch                  " highlight matching ({})

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


"-------------------------------PLUGINS----------------------------------------

"vim-autoformat
:noremap <F3> :Autoformat<CR>

"syntastic
:set statusline+=%#warningmsg#
:set statusline+=%{SyntasticStatuslineFlag()}
:set statusline+=%*

:let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
:let g:syntastic_check_on_open = 1
:let g:syntastic_check_on_wq = 0

"commentary
:autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
:noremap <leader>/ :Commentary<cr>
"change comment style to // inplace of /* */

"------------------------------EXPERIMENTS-------------------------------------
