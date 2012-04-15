set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/ 
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'rails.vim'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
" ...
" auto complete
Bundle 'AutoComplPop'

" JAVA
Bundle 'JavaRun'
Bundle 'JavaDecompiler.vim'
" Bundle 'javacomplete'

" Web Vundles {{{1
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'mattn/zencoding-vim'
Bundle 'sukima/xmledit'
Bundle 'jsbeautify'
Bundle 'vim-coffee-script'
Bundle 'JavaScript-syntax'
" " }}}1
"
Bundle 'winmanager--Fox'
Bundle 'taglist.vim'
Bundle 'taglist-plus'
Bundle 'minibufexpl.vim'
Bundle 'The-NERD-tree'

"colour
Bundle 'blue_sky'
filetype plugin indent on     " required!
" or 
" filetype plugin on          " to not use the indentation settings set by plugins

if &t_Co > 2 || has("gui_running")
 syntax on
 set hlsearch
endif

set mouse=n

set fileencodings=ucs-bom,utf8,GB18030,Big5,latin1
"set cursorline
set laststatus=2
set showcmd
set cmdheight=2
set ignorecase

let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Use_Right_Window=1
let Tlist_Show_Menu=1
"let Tlist_Auto_Open=1
"

"let g:winManagerWindowLayout='NERDTree|Tlist'
let g:winManagerWidth = 30
nmap wm :WMToggle<cr>
nmap <C-F4> :WMToggle<cr>:q<cr>
nmap <F4> :WMToggle<cr>
nmap <F5> :NERDTree<cr>
nmap <F3> <C-w><C-w>

let tlist_js_settings = 'javascript;s:string;a:array;o:object;f:function'

