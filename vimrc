"PluginManager
"Pathogen
"execute pathogen#infect()       
                                " install pathogen plugin manager if version <8
"Basic
filetype indent plugin on       " turn on filetype based indenting and syntax highlighting 
syntax on                                                                          
:set wildmenu                   " auto complete in command-line mode               
:set wildmode=longest:full,full                                                    

"UI                                                                                
:set number                     " view line numbers                                
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
