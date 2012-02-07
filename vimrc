set nocompatible
set bs=2		" Allow backspacing over everything in insert
set ai			" Auto-indent on
set history=50		" 50 lines of history
set ruler		" Always show cursor position
"set et			" Expand Tab
set sw=4		" Shift width
set smarttab            " Deletes as much as it tabs
set tabstop=4
set expandtab

set modelines=0
set nomodeline

set viminfo='20,\"500

syntax enable

if &term=="xterm"
	set t_Co=8
	set t_Sb=^[4%dm
	set t_Sf=^[3%dm
endif

set backspace=indent,eol,start
set showcmd
set incsearch

inoremap <C-U> <C-G>u<C-U>

if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

	set autoindent		" always set autoindenting on

endif " has("autocmd")

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

map Q gq

if has ('mouse')
	set mouse=a
endif

if has('gui_running')
	map <S-Insert> <MiddleMouse>
	map! <S-Insert> <MiddleMouse>
endif

cmap Q q

au BufRead,BufNewFile *.include setfiletype xml
au BufRead,BufNewFile *.build   setfiletype xml
au BufRead,BufNewFile *.md,*.mkdn,*.markdown   set filetype=markdown

set viminfo='20,\"500	" keep a .viminfo file

" syntax highlighting if terminal supports it
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term ==? "gnome" && has("eval")
 " Set useful keys that vim doesn't discover via termcap but are in the
 " builtin xterm termcap. See bug #122562. We use exec to avoid having to
 " include raw escapes in the file.
  exec "set <C-Left>=\eO5D"
  exec "set <C-Right>=\eO5C"
endif

if isdirectory(expand("$VIMRUNTIME/ftplugin"))
  filetype plugin on
  "filetype indent on
endif

if has("eval")
  let is_bash=1
endif

"colorscheme DarkDefault


":au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

let g:xml_syntax_folding = 1
set foldenable
set foldmethod=syntax
set foldlevel=999
set clipboard=unnamed

if exists('+colorcolumn')
  set colorcolumn=80
  hi ColorColumn ctermbg=darkgrey guibg=darkgrey
endif

let mapleader = ","
let g:pep8_map='<leader>8'

call pathogen#infect()
call pathogen#helptags()


" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" Execute the tests
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
" cycle through test errors
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest error<CR>

map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

set ignorecase 
set smartcase
set scrolloff=3

set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

set shortmess=atI

source ~/.vimrc.rfi
source ~/.vimrc.private
